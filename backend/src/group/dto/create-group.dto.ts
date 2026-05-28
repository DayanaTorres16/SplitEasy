import { IsString, IsNotEmpty, IsOptional, IsNumber, IsArray, ValidateNested, IsEmail } from 'class-validator';
import { Type, Transform } from 'class-transformer';

class MiembroDto {
  @IsString()
  @IsNotEmpty()
  nombre!: string;

  @IsEmail()
  @IsOptional()
  // Intercepta strings vacíos y los transforma en undefined para que @IsOptional() actúe correctamente
  @Transform(({ value }) => value === '' ? undefined : value) 
  email?: string;
}

export class CreateGroupDto {
  @IsString()
  @IsNotEmpty()
  nombre!: string;

  @IsString()
  @IsOptional()
  descripcion?: string;

  @IsNumber()
  iconoIndex!: number;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => MiembroDto)
  @IsOptional()
  miembros?: MiembroDto[];
}