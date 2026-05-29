import { Repository } from 'typeorm';
import { Usuario } from './usuario.entity';
import { UpdateUsuarioDto } from './dto/update-usuario.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
export declare class UsuariosService {
    private readonly repo;
    constructor(repo: Repository<Usuario>);
    findAll(): Promise<Usuario[]>;
    findById(id: number): Promise<Usuario | null>;
    findByEmail(email: string): Promise<Usuario | null>;
    create(data: Partial<Usuario>): Promise<Usuario>;
    updatePassword(id: number, passwordHash: string): Promise<Usuario>;
    updateProfile(id: number, dto: UpdateUsuarioDto): Promise<Omit<Usuario, 'password_hash'>>;
    changePassword(id: number, dto: ChangePasswordDto): Promise<{
        message: string;
    }>;
}
