<%--
    datos.jsp -> CATALOGO DE PRODUCTOS (aqui agregas / editas tus productos)
    Se incluye con <%@ include file="datos.jsp" %> en index.jsp y carrito.jsp
--%>
<%@ page import="java.util.*" %>
<%!
    // Metodo auxiliar para crear un producto rapido
    public Map<String, Object> nuevoProducto(String id, String marca, String nombre,
            double precio, double precioAntes, String badge, int estrellas, String... fotos) {
        Map<String, Object> p = new LinkedHashMap<String, Object>();
        p.put("id", id);
        p.put("marca", marca);
        p.put("nombre", nombre);
        p.put("precio", precio);
        p.put("precioAntes", precioAntes);
        p.put("badge", badge);
        p.put("estrellas", estrellas);
        p.put("fotos", Arrays.asList(fotos));
        return p;
    }

    // Busca un producto por su id dentro de la lista
    public Map<String, Object> buscarProducto(List<Map<String, Object>> lista, String id) {
        if (id == null) return null;
        for (Map<String, Object> p : lista) {
            if (id.equals(p.get("id"))) return p;
        }
        return null;
    }
%>
<%
    // ====== LISTA DE PRODUCTOS ======
    // nuevoProducto(id, marca, nombre, precio, precioAntes, badge, estrellas, fotos...)
    List<Map<String, Object>> productos = new ArrayList<Map<String, Object>>();

    productos.add(nuevoProducto("1", "Hy-Line", "Gallina ponedora Hy-Line Brown - lote de 10 unidades",
            22.00, 28.00, "-21%", 5, "FOTOS/1.jpg", "FOTOS/2.jpg", "FOTOS/3.jpg"));

    productos.add(nuevoProducto("2", "Hy-Line", "Ponedora Hy-Line W-36 blanca - alta postura",
            23.00, 29.00, "-20%", 4, "FOTOS/2.jpg", "FOTOS/1.jpg", "FOTOS/3.jpg"));

    productos.add(nuevoProducto("3", "Lohmann", "Lohmann Brown Classic - pie de cr&iacute;a certificado",
            22.00, 26.50, "-17%", 5, "FOTOS/3.jpg", "FOTOS/1.jpg", "FOTOS/2.jpg"));

    productos.add(nuevoProducto("4", "Ross", "Pollo BB Ross 308 - engorde r&aacute;pido (por unidad)",
            2.50, 3.20, "-22%", 4, "FOTOS/4.jpg", "FOTOS/5.jpg", "FOTOS/6.jpg"));

    productos.add(nuevoProducto("5", "Cobb", "Pollo BB Cobb 500 - alta conversi&oacute;n alimenticia",
            2.50, 3.00, "-17%", 5, "FOTOS/5.jpg", "FOTOS/4.jpg", "FOTOS/6.jpg"));

    productos.add(nuevoProducto("6", "Arbor Acres", "Arbor Acres Plus - l&iacute;nea gen&eacute;tica premium",
            2.40, 2.90, "-17%", 4, "FOTOS/6.jpg", "FOTOS/4.jpg", "FOTOS/5.jpg"));
%>