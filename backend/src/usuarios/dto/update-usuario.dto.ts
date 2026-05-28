import { IsEmail, IsOptional, IsString, Length } from 'class-validator';

export class UpdateUsuarioDto {
  @IsOptional()
  @IsString()
  @Length(3, 100)
  nombre?: string;

  @IsOptional()
  @IsEmail()
  @Length(5, 150)
  email?: string;
}