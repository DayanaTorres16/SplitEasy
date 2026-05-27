import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { UsuariosService } from './usuarios.service';
import { Usuario } from './usuario.entity';

@Controller('usuarios')
export class UsuariosController {
  constructor(private readonly service: UsuariosService) {}

  @Get()
  findAll(): Promise<Usuario[]> {
    return this.service.findAll();
  }

  @Get(':id')
  findById(@Param('id') id: number): Promise<Usuario | null> {
    return this.service.findById(id);
  }

  @Post()
  create(@Body() body: Partial<Usuario>): Promise<Usuario> {
    return this.service.create(body);
  }
}
