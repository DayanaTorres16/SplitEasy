import { IsString, IsNotEmpty, IsOptional, IsNumber, IsArray, ValidateNested, IsEmail } from 'class-validator';
import { Type, Transform } from 'class-transformer';

class MiembroDto {
  @IsString()
  @IsNotEmpty()
  nombre!: string;

  @IsEmail()
  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : value) 
  email?: string;
}

export class CreateGroupDto {
  @IsString()
  @IsNotEmpty()
  nombre!: string;

  @IsOptional()
  descripcion?: string;

  @IsNumber()
  iconoIndex!: number;

  @IsArray()
  @IsNumber({}, { each: true }) 
  @IsOptional()
  miembrosIds?: number[]; 

}