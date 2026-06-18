import { prisma } from "./prisma";
import { dateTimeOf } from "./time";

// Pure auto-release sweep — releases RESERVED bookings whose start time passed
// more than `autoReleaseMinutes` ago without a check-in. No revalidation, so it
// is safe to call during a server-component render (the caller re-queries after).
export async function sweepExpiredBookings(): Promise<number> {
  const settings = await prisma.appSettings.findUnique({
    where: { id: "singleton" },
  });
  const minutes = settings?.autoReleaseMinutes ?? 30;
  const now = Date.now();

  const reserved = await prisma.booking.findMany({
    where: { status: "RESERVED" },
    select: { id: true, date: true, startTime: true, createdAt: true },
  });

  const expired = reserved.filter((b) => {
    const start = dateTimeOf(b.date, b.startTime).getTime();
    // The check-in grace window runs from the later of the booking's start
    // time or when it was created — so a desk booked after its nominal start
    // (e.g. an afternoon walk-in for a 09:00 slot) still gets the full window
    // instead of being released the instant it's created.
    const windowStart = Math.max(start, b.createdAt.getTime());
    return now > windowStart + minutes * 60_000;
  });

  if (expired.length === 0) return 0;
  await prisma.booking.updateMany({
    where: { id: { in: expired.map((b) => b.id) } },
    data: { status: "RELEASED" },
  });
  return expired.length;
}
