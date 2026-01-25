import { AuthService } from "../../domain/services/AuthService";
import { Result } from "../../shared/Result";

export class RegisterUseCase {
  constructor(private readonly authService: AuthService) {}

  public async execute(email: string, password: string): Promise<Result<{ token: string }>> {
    const result = await this.authService.register(email, password);
    if (result.isFailure) {
      return Result.fail(result.error as string);
    }
    return Result.ok({ token: result.value.token });
  }
}
