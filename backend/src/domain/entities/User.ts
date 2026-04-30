import { Email } from "../value-objects/Email";
import { Password } from "../value-objects/Password";
import { Role } from "../../shared/types";
import { ROLE_PERMISSIONS } from "../../shared/constants";

export class User {
  public updatedAt: Date;

  constructor(
    public readonly id: string,
    public email: Email,
    public password: Password,
    public firstName: string,
    public lastName: string,
    public role: Role,
    public createdAt: Date,
    updatedAt?: Date,
    public isActive = true,
    public vkId?: string
  ) {
    this.updatedAt = updatedAt ?? createdAt;
  }

  public isStudent(): boolean {
    return this.role === "STUDENT";
  }

  public isTeacher(): boolean {
    return this.role === "TEACHER";
  }

  public isAdmin(): boolean {
    return this.role === "ADMIN" || this.role === "SUPERADMIN";
  }

  public hasPermission(permission: string): boolean {
    return ROLE_PERMISSIONS[this.role].includes(permission as never);
  }

  public verify(password: string): boolean {
    return this.password.compare(password);
  }

  public updateLastLogin(): void {
    this.updatedAt = new Date();
  }

  /**
   * Updates user profile fields.
   * Only updates provided fields (partial update).
   */
  public updateProfile(firstName?: string, lastName?: string): void {
    if (firstName !== undefined) this.firstName = firstName;
    if (lastName !== undefined) this.lastName = lastName;
    this.updatedAt = new Date();
  }

  /**
   * Replaces current password with a new one.
   * Caller is responsible for verifying old password before calling this.
   */
  public changePassword(newPassword: Password): void {
    this.password = newPassword;
    this.updatedAt = new Date();
  }

  public toJSON() {
    return {
      id: this.id,
      email: this.email.value,
      firstName: this.firstName,
      lastName: this.lastName,
      role: this.role,
      createdAt: this.createdAt.toISOString(),
      updatedAt: this.updatedAt.toISOString(),
      isActive: this.isActive,
      vkId: this.vkId,
    };
  }
}
