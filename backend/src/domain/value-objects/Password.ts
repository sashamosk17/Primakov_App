import { createHash } from "crypto";

export class Password {
  private constructor(private readonly _encrypted: string) {}

  public get encrypted(): string {
    return this._encrypted;
  }

  public compare(plainText: string): boolean {
    return Password.hash(plainText) === this._encrypted;
  }

  public static create(plainText: string): Password {
    return new Password(Password.hash(plainText));
  }

  private static hash(plainText: string): string {
    return createHash("sha256").update(plainText).digest("hex");
  }
}
