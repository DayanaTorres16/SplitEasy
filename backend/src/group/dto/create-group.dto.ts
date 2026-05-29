import { IsString, IsNotEmpty, IsOptional, IsNumber, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

class ExternalMemberDto {
  @IsString()
  @IsNotEmpty()
  nombre!: string;

  @IsOptional()
  @IsString()
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

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ExternalMemberDto)
  miembros?: ExternalMemberDto[];
}
