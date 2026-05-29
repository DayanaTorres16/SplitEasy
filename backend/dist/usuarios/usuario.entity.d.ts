import { Grupo } from '../group/group.entity';
export declare class Usuario {
    id: number;
    nombre: string;
    email: string;
    password_hash: string;
    fecha_registro: Date;
    grupos: Grupo[];
}
