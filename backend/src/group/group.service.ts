import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Grupo } from './group.entity';
import { Usuario } from '../usuarios/usuario.entity';
import { CreateGroupDto } from './dto/create-group.dto';

@Injectable()
export class GruposService {
  constructor(
    @InjectRepository(Grupo)
    private readonly grupoRepository: Repository<Grupo>,
    @InjectRepository(Usuario)
    private readonly usuarioRepository: Repository<Usuario>,
  ) {}

  // Cambiamos usuarioLogueadoId a tipo number para que coincida con tu BD
  async crear(createGroupDto: CreateGroupDto, usuarioLogueadoId: number): Promise<Grupo> {
    
    // 1. Buscar al usuario organizador (tú) usando el ID numérico
    const organizador = await this.usuarioRepository.findOne({ where: { id: usuarioLogueadoId } });
    if (!organizador) {
      throw new NotFoundException('Usuario organizador no encontrado');
    }

    // 2. Inicializar la lista de miembros con el organizador
    const listaMiembros: Usuario[] = [organizador];

    // 3. Procesar miembros adicionales enviados desde el front
    if (createGroupDto.miembros && createGroupDto.miembros.length > 0) {
      for (const miembroDto of createGroupDto.miembros) {
        if (miembroDto.email) {
          const usuarioExistente = await this.usuarioRepository.findOne({ where: { email: miembroDto.email } });
          
          if (usuarioExistente) {
            listaMiembros.push(usuarioExistente);
          } else {
            // Ajustado a las propiedades de tu entidad: 'password_hash' en lugar de 'password'
            const nuevoUsuarioTemporal = this.usuarioRepository.create({
              nombre: miembroDto.nombre,
              email: miembroDto.email,
              password_hash: 'temporal_sin_clave', 
            });
            // Forzamos el tipado de retorno para evitar que confunda un objeto con un array
            const usuarioGuardado = await this.usuarioRepository.save(nuevoUsuarioTemporal) as Usuario;
            listaMiembros.push(usuarioGuardado);
          }
        } else {
          // Si no viene email, generamos uno temporal único
          const usuarioAmigo = this.usuarioRepository.create({
            nombre: miembroDto.nombre,
            email: `temporal_${Date.now()}_${Math.random().toString(36).substring(5)}@spliteasy.com`,
            password_hash: 'amigo_temporal',
          });
          const amigoGuardado = await this.usuarioRepository.save(usuarioAmigo) as Usuario;
          listaMiembros.push(amigoGuardado);
        }
      }
    }

    // 4. Crear la instancia del grupo con sus relaciones mapeadas
    const nuevoGrupo = this.grupoRepository.create({
      nombre: createGroupDto.nombre,
      descripcion: createGroupDto.descripcion,
      iconoIndex: createGroupDto.iconoIndex,
      miembros: listaMiembros, 
    });

    // 5. Guardar el grupo definitivo en PostgreSQL
    return this.grupoRepository.save(nuevoGrupo);
  }
}