﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using PetaPoco;
using System.Web.Mvc;
using System.Web.WebPages;
using DataAnnotationsExtensions;

namespace Site.Models {
    [TableName("ItemMercaderia")]
    [PrimaryKey("ItemMercaderiaID")]
    [ExplicitColumns]
    public class ItemMercaderia {

        [PetaPoco.Column("ItemMercaderiaID")]
        [Display(Name="ID")]
        public int ItemMercaderiaID { get; set; }
        
        [PetaPoco.Column("Peso")]
        [Display(Name="Peso (Kg)")]
        [Range(0,100000)]
        public double Peso{ get; set; }

        [PetaPoco.Column("Precio")]
        [Display(Name="Precio ($)")]
        [Range(0,100000)]
        public double Precio{ get; set; }

        [PetaPoco.Column("PrecioKg")]
        [Display(Name="Precio<br/>por Kg ($)")]
        [Range(0,100000)]
        public double PrecioKg{ get; set; }

        [PetaPoco.Column("PrecioUnitario")]
        [Display(Name="Precio Unitario ($)")]
        [Range(0,100000)]
        public double PrecioUnitario{ get; set; }

        [PetaPoco.Column("PesoUnitario")]
        [Display(Name="Peso Unitario (Kg)")]
        [Range(0,100000)]
        public double PesoUnitario{ get; set; }

        [PetaPoco.Column("Cantidad")]
        [Display(Name="Cantidad")]
        [Range(0,100000)]
        public int Cantidad { get; set; }

        [PetaPoco.Column("Bultos")]
        [Display(Name="Bultos")]
        [Range(0,100000)]
        public int Bultos { get; set; }

        [PetaPoco.Column("MercaderiaID")]
        public int MercaderiaID { get; set; }

        [PetaPoco.Column("ProductoID")]
        public int ProductoID { get; set; }
        
        [ResultColumn]
        [Display(Name="Código Artículo")]
        public int? CodigoArticulo { get; set; }

        [ResultColumn]
        [Display(Name="Descripción")]
        public String Descripcion { get; set; }
        

        
		[Display(Name = "Producto")]
        public String Producto {
            get {
                if (!CodigoArticulo.IsEmpty() && !Descripcion.IsEmpty())
                    return CodigoArticulo.ToString() + " - " + Descripcion;

                return !CodigoArticulo.IsEmpty() ? CodigoArticulo.ToString() : Descripcion;
            }
        }

        [ResultColumn]
        public int ProveedorID{ get; set; }
        
        public static PetaPoco.Sql BaseQuery(int TopN = 0) {
            var sql = PetaPoco.Sql.Builder;
		    sql.AppendSelectTop(TopN);
            sql.Append("ItemMercaderia.*, Producto.Descripcion as Descripcion, Producto.CodigoArticulo as CodigoArticulo, Producto.UsuarioID as ProveedorID");
            sql.Append("FROM ItemMercaderia");
            sql.Append("INNER JOIN Producto ON Producto.ProductoID = ItemMercaderia.ProductoID");
            return sql;
        }
        
        public bool IsValid(ModelStateDictionary state) {
            
            return true;
        }

        public void actualizarAgregaciones( bool esValorAbsoluto,ItemMercaderia other) {
            if (esValorAbsoluto) {
                this.Cantidad = other.Cantidad;
                this.Precio = other.Precio;
                this.Peso = other.Peso;
                this.Bultos = other.Bultos;
                // asi se mantendrán actualizados los valores que no son agregaciones.
                this.PrecioKg = other.PrecioKg;
                this.PrecioUnitario = other.PrecioUnitario;
                this.PesoUnitario = other.PesoUnitario;
            }
            else {
                this.Peso += other.Peso;
                this.Cantidad += other.Cantidad;
                this.Precio += other.Precio;
                this.Bultos += other.Bultos;
            }     

            this.Cantidad = this.Cantidad>0?this.Cantidad :0 ;
            this.Precio = this.Precio>0?this.Precio :0 ;
            this.Peso = this.Peso>0?this.Peso :0 ;
            this.Bultos = this.Bultos>0?this.Bultos :0 ;
            this.PrecioKg = this.PrecioKg>0?this.PrecioKg :0 ;
            this.PrecioUnitario = this.PrecioUnitario>0?this.PrecioUnitario :0;
            this.PesoUnitario = this.PesoUnitario>0?this.PesoUnitario :0 ;
        }

        public bool sinExistencias() {
            return Cantidad == 0;//&& Peso == 0 && Bultos == 0; solo se valida que se acabaron las cantidades para determinar si se agoto un producto.
        }

        public bool Equals(ItemMercaderia other) {
            return this.ProductoID == other.ProductoID && this.Cantidad == other.Cantidad && this.Precio == other.Precio && this.PrecioKg == other.PrecioKg && this.Peso == other.Peso && this.Bultos == other.Bultos  && this.PrecioUnitario == other.PrecioUnitario;
        }

        public ItemMercaderia clone() {            
            var newItemMercaderia = new ItemMercaderia();
            newItemMercaderia.Cantidad = this.Cantidad;
            newItemMercaderia.Peso = this.Peso;
            newItemMercaderia.Precio = this.Precio;
            newItemMercaderia.Bultos = this.Bultos;
            newItemMercaderia.PrecioKg = this.PrecioKg;
            newItemMercaderia.PrecioUnitario = this.PrecioUnitario;
            newItemMercaderia.PesoUnitario = this.PesoUnitario;
            newItemMercaderia.ProductoID = this.ProductoID;
            newItemMercaderia.ProveedorID = this.ProveedorID;
            newItemMercaderia.Descripcion = this.Descripcion;
            newItemMercaderia.CodigoArticulo = this.CodigoArticulo;
            return newItemMercaderia;
        }

    }
}