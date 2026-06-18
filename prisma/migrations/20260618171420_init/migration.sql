-- CreateTable
CREATE TABLE "Premise" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "mapWidth" INTEGER NOT NULL DEFAULT 1200,
    "mapHeight" INTEGER NOT NULL DEFAULT 800,
    "backgroundUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Premise_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Zone" (
    "id" TEXT NOT NULL,
    "premiseId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'FOCUS',
    "color" TEXT NOT NULL DEFAULT '#14b8a6',
    "x" DOUBLE PRECISION NOT NULL DEFAULT 40,
    "y" DOUBLE PRECISION NOT NULL DEFAULT 40,
    "width" DOUBLE PRECISION NOT NULL DEFAULT 280,
    "height" DOUBLE PRECISION NOT NULL DEFAULT 220,

    CONSTRAINT "Zone_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bookable" (
    "id" TEXT NOT NULL,
    "premiseId" TEXT NOT NULL,
    "zoneId" TEXT,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'DESK',
    "isAvailable" BOOLEAN NOT NULL DEFAULT true,
    "timesAvailable" TEXT NOT NULL DEFAULT '[]',
    "tags" TEXT NOT NULL DEFAULT '[]',
    "textDescription" TEXT NOT NULL DEFAULT '',
    "x" DOUBLE PRECISION NOT NULL DEFAULT 100,
    "y" DOUBLE PRECISION NOT NULL DEFAULT 100,

    CONSTRAINT "Bookable_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Booker" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "team" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'USER',

    CONSTRAINT "Booker_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Booking" (
    "id" TEXT NOT NULL,
    "bookerId" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "startTime" TEXT NOT NULL DEFAULT '09:00',
    "endTime" TEXT NOT NULL DEFAULT '17:00',
    "repeat" TEXT NOT NULL DEFAULT 'NONE',
    "bookingTitle" TEXT NOT NULL DEFAULT '',
    "bookingGuidance" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL DEFAULT 'RESERVED',
    "checkInAt" TIMESTAMP(3),
    "checkOutAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Booking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AppSettings" (
    "id" TEXT NOT NULL DEFAULT 'singleton',
    "autoReleaseMinutes" INTEGER NOT NULL DEFAULT 30,

    CONSTRAINT "AppSettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_BookingBookables" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_BookingBookables_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Booker_email_key" ON "Booker"("email");

-- CreateIndex
CREATE INDEX "_BookingBookables_B_index" ON "_BookingBookables"("B");

-- AddForeignKey
ALTER TABLE "Zone" ADD CONSTRAINT "Zone_premiseId_fkey" FOREIGN KEY ("premiseId") REFERENCES "Premise"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bookable" ADD CONSTRAINT "Bookable_premiseId_fkey" FOREIGN KEY ("premiseId") REFERENCES "Premise"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bookable" ADD CONSTRAINT "Bookable_zoneId_fkey" FOREIGN KEY ("zoneId") REFERENCES "Zone"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Booking" ADD CONSTRAINT "Booking_bookerId_fkey" FOREIGN KEY ("bookerId") REFERENCES "Booker"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BookingBookables" ADD CONSTRAINT "_BookingBookables_A_fkey" FOREIGN KEY ("A") REFERENCES "Bookable"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BookingBookables" ADD CONSTRAINT "_BookingBookables_B_fkey" FOREIGN KEY ("B") REFERENCES "Booking"("id") ON DELETE CASCADE ON UPDATE CASCADE;
