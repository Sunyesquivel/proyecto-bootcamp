import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Float "mo:base/Float";

actor calculadora{
    // Estructura para cada material en el inventario
    type Material = {
        nombre_del_material: Text;
        costo_por_unidad: Float;    
        cantidad_en_inventario: Nat;           
    };

    // Estructura para el material en un proyecto
    type Materiales_del_proyecto = {
        nombre_del_material: Text;
        material_requerido: Nat;
    };

    // Inventario de materiales usando HashMap
    var inventory : HashMap.HashMap<Text, Material> = HashMap.HashMap<Text, Material>(
        10,  // Tamaño inicial del HashMap
        Text.equal,  // Función para comparar claves de tipo Text
        Text.hash    // Función de hash para claves de tipo Text
    );

    // Función para agregar un material al inventario
    public func AGREGARMATERIAL(nombre_del_material: Text, costo_por_unidad: Float, cantidad_en_inventario: Nat) : async Text {
        inventory.put(nombre_del_material, { nombre_del_material;costo_por_unidad; cantidad_en_inventario });
        return "SE AGREGO MATERIAL AL INVENTARIO :) ";
    };

    // Función para actualizar el costo unitario de un material
    public func ActualizacionDelCostoUnitario(nombre_del_material: Text, nuevo_costo_unitario: Float) : async Text {
        let materialOpt = inventory.get(nombre_del_material);
        switch (materialOpt) {
            case (?material) {
                let actulizarMaterial = { nombre_del_material= material.nombre_del_material; costo_por_unidad = nuevo_costo_unitario; cantidad_en_inventario = material.cantidad_en_inventario };
                inventory.put(nombre_del_material, actulizarMaterial);
                return "SE ACTUALIZO EL COSTO UNITARIO.";
            };
            case (null) {
                return "EL MATERIAL NO FUE ENCONTRADO EN EL INVENTARIO";
            };
        };
    };

    // Función para calcular el costo total de un proyecto
    public func CalcularCostoDelProyecto(Materiales_del_proyecto: [Materiales_del_proyecto]) : async Float {
        var costo_total : Float = 0.0;

        for (projMat in Materiales_del_proyecto.vals()) {
            let materialOpt = inventory.get(projMat.nombre_del_material);
            switch (materialOpt) {
                case (?material) {
                    if (projMat.material_requerido<= material.cantidad_en_inventario) {
                        costo_total += Float.fromInt(projMat.material_requerido) * material.costo_por_unidad;
                    } else {
                        Debug.print("No hay suficiente stock de " # projMat.nombre_del_material# ".");
                    };
                };
                case (null) {
                    Debug.print("El material " # projMat.nombre_del_material # " no se encuentra en el inventario.");
                };
            };
        };
        return costo_total;
    };
} 