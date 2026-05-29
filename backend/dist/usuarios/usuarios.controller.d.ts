import { UsuariosService } from './usuarios.service';
import { UpdateUsuarioDto } from './dto/update-usuario.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
export declare class UsuariosController {
    private readonly usuariosService;
    constructor(usuariosService: UsuariosService);
    getProfile(req: any): Promise<{
        id: number;
        nombre: string;
        email: string;
        fecha_registro: Date;
        grupos: import("../group/group.entity").Grupo[];
    }>;
    updateProfile(req: any, dto: UpdateUsuarioDto): Promise<Omit<import("./usuario.entity").Usuario, "password_hash">>;
    changePassword(req: any, dto: ChangePasswordDto): Promise<{
        message: string;
    }>;
    logout(): Promise<{
        message: string;
    }>;
    buscarPorEmail(email: string): Promise<import("./usuario.entity").Usuario | null>;
}
