import { Controller, Post, Body, UseGuards, Req, UnauthorizedException } from '@nestjs/common';
import { GruposService }  from './group.service';
import { CreateGroupDto } from './dto/create-group.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard'; 

@Controller('grupos')
@UseGuards(JwtAuthGuard) 
export class GruposController {
  constructor(private readonly gruposService: GruposService) {}

  @Post()
  async crearGrupo(
    @Body() createGroupDto: CreateGroupDto,
    @Req() req: any
  ) {
    // Apuntamos directamente a 'userId' que es como lo nombra tu JwtStrategy
    const usuarioLogueadoId = req.user?.userId;

    if (!usuarioLogueadoId) {
      throw new UnauthorizedException(
        'No se pudo identificar al usuario autenticado (userId no encontrado en req.user).'
      );
    }

    // Como ya viene de la estrategia, pasamos el ID directamente al servicio
    return this.gruposService.crear(createGroupDto, usuarioLogueadoId);
  }
}