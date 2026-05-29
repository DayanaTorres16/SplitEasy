import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Usuario } from '../usuarios/usuario.entity'; 
import { Grupo } from '../group/group.entity'; // <-- Corregido con ../ por la estructura de carpetas

@Entity('gastos')
export class Expense { // <-- Asegúrate de que se llame exactamente 'Expense' con mayúscula
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  monto!: number;

  @Column()
  descripcion!: string;

  @Column({ default: 'Comida' })
  categoria!: string;

  @CreateDateColumn({ name: 'fecha_gasto' })
  fechaGasto!: Date;

  @ManyToOne(() => Usuario, { eager: true, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'pagado_por_id' })
  pagadoPor!: Usuario;

  @ManyToOne(() => Grupo, { onDelete: 'CASCADE' }) 
  @JoinColumn({ name: 'grupo_id' })
  grupo!: Grupo;
}