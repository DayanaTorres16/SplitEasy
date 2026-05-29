import { Entity, PrimaryGeneratedColumn, Column, ManyToMany } from 'typeorm';
import { Grupo } from '../group/group.entity'

@Entity('usuarios')
export class Usuario {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ length: 100 })
  nombre!: string;

  @Column({ unique: true, length: 150 })
  email!: string;

  @Column({ length: 255 })
  password_hash!: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  fecha_registro!: Date;

  @ManyToMany(() => Grupo, (grupo) => grupo.miembros)
  grupos!: Grupo[];
}
