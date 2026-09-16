import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    status: "foundation",
    message: "Evidence API endpoint reserved for the v0.1 evidence service."
  });
}
