<%-- 
    Document   : carrito.jsp
    Created on : 16 set. 2026, 7:54:05 p. m.
    Author     : PEREZ FFAA
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="datos.jsp" %>
<%
    DecimalFormat fmt = new DecimalFormat("#,##0.00");

    // ====== CARRITO EN SESION ======
    List<Map<String, Object>> carrito = (List<Map<String, Object>>) session.getAttribute("carrito");
    if (carrito == null) {
        carrito = new ArrayList<Map<String, Object>>();
        session.setAttribute("carrito", carrito);
    }

    String accion = request.getParameter("accion");
    String idParam = request.getParameter("id");

    if ("agregar".equals(accion)) {
        Map<String, Object> prod = buscarProducto(productos, idParam);
        if (prod != null) {
            boolean existe = false;
            for (Map<String, Object> it : carrito) {
                if (it.get("id").equals(idParam)) {
                    it.put("cantidad", (Integer) it.get("cantidad") + 1);
                    existe = true;
                    break;
                }
            }
            if (!existe) {
                Map<String, Object> item = new LinkedHashMap<String, Object>();
                item.put("id", prod.get("id"));
                item.put("marca", prod.get("marca"));
                item.put("nombre", prod.get("nombre"));
                item.put("precio", prod.get("precio"));
                item.put("imagen", ((List<String>) prod.get("fotos")).get(0));
                item.put("cantidad", 1);
                carrito.add(item);
            }
        }
        if ("1".equals(request.getParameter("volver"))) {
            response.sendRedirect("index.jsp?msg=agregado#catalogo");
            return;
        }
        response.sendRedirect("carrito.jsp");
        return;

    } else if ("mas".equals(accion) || "menos".equals(accion)) {
        Iterator<Map<String, Object>> it = carrito.iterator();
        while (it.hasNext()) {
            Map<String, Object> item = it.next();
            if (item.get("id").equals(idParam)) {
                int cant = (Integer) item.get("cantidad");
                cant = "mas".equals(accion) ? cant + 1 : cant - 1;
                if (cant <= 0) { it.remove(); } else { item.put("cantidad", cant); }
                break;
            }
        }
        response.sendRedirect("carrito.jsp");
        return;

    } else if ("quitar".equals(accion)) {
        Iterator<Map<String, Object>> it = carrito.iterator();
        while (it.hasNext()) {
            if (it.next().get("id").equals(idParam)) { it.remove(); break; }
        }
        response.sendRedirect("carrito.jsp");
        return;

    } else if ("vaciar".equals(accion)) {
        carrito.clear();
        response.sendRedirect("carrito.jsp");
        return;
    }

    // ====== TOTALES ======
    double subtotal = 0;
    int totalItems = 0;
    for (Map<String, Object> item : carrito) {
        subtotal += (Double) item.get("precio") * (Integer) item.get("cantidad");
        totalItems += (Integer) item.get("cantidad");
    }
    double envio  = (subtotal > 0 && subtotal < 150) ? 15.00 : 0.00;
    double igv    = subtotal * 0.18;               // IGV incluido (referencial)
    double total  = subtotal + envio;
    session.setAttribute("totalPagar", total);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi carro | elrico.com.pe</title>
    <link rel="stylesheet" href="estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%@ include file="cabecera.jsp" %>

<div class="pagina">
    <div class="migas"><a href="index.jsp">Inicio</a> / Mi carro</div>
    <h1>Mi carro (<%= totalItems %> producto<%= totalItems == 1 ? "" : "s" %>)</h1>

<% if (carrito.isEmpty()) { %>

    <div class="caja">
        <div class="vacio">
            <i class="fa-solid fa-cart-shopping"></i>
            <h2>Tu carro est&aacute; vac&iacute;o</h2>
            <p>Agrega productos del cat&aacute;logo para continuar con tu compra.</p>
            <a href="index.jsp" class="btn-secundario">Ir al cat&aacute;logo</a>
        </div>
    </div>

<% } else { %>

    <div class="grid-checkout">
        <div>
            <div class="caja">
                <h2>Productos seleccionados</h2>
                <table class="tabla-carrito">
                    <tr>
                        <th colspan="2">Producto</th>
                        <th>Precio</th>
                        <th>Cantidad</th>
                        <th>Total</th>
                        <th></th>
                    </tr>
                    <%
                        for (Map<String, Object> item : carrito) {
                            String iid   = (String) item.get("id");
                            double prec  = (Double) item.get("precio");
                            int cant     = (Integer) item.get("cantidad");
                    %>
                    <tr>
                        <td><img src="<%= item.get("imagen") %>" alt=""></td>
                        <td>
                            <div style="font-size:12px;color:#767676;font-weight:800;"><%= item.get("marca") %></div>
                            <div class="nom"><%= item.get("nombre") %></div>
                        </td>
                        <td>S/ <%= fmt.format(prec) %></td>
                        <td>
                            <div class="cant-control">
                                <a href="carrito.jsp?accion=menos&amp;id=<%= iid %>">&minus;</a>
                                <b><%= cant %></b>
                                <a href="carrito.jsp?accion=mas&amp;id=<%= iid %>">+</a>
                            </div>
                        </td>
                        <td><b>S/ <%= fmt.format(prec * cant) %></b></td>
                        <td><a class="link-quitar" href="carrito.jsp?accion=quitar&amp;id=<%= iid %>">
                            <i class="fa-regular fa-trash-can"></i> Quitar</a></td>
                    </tr>
                    <% } %>
                </table>

                <div style="margin-top:18px;display:flex;gap:12px;flex-wrap:wrap;">
                    <a href="index.jsp" class="btn-secundario">Seguir comprando</a>
                    <a href="carrito.jsp?accion=vaciar" class="btn-secundario">Vaciar carro</a>
                </div>
            </div>
        </div>

        <div class="caja">
            <h2>Resumen de la orden</h2>
            <div class="resumen-fila"><span>Subtotal (<%= totalItems %> items)</span><span>S/ <%= fmt.format(subtotal) %></span></div>
            <div class="resumen-fila"><span>Despacho</span>
                <span><%= envio == 0 ? "Gratis" : "S/ " + fmt.format(envio) %></span></div>
            <div class="resumen-fila" style="color:#767676;font-size:13px;">
                <span>IGV incluido (18%)</span><span>S/ <%= fmt.format(igv) %></span></div>
            <div class="resumen-total"><span>Total</span><span>S/ <%= fmt.format(total) %></span></div>

            <% if (envio > 0) { %>
                <p style="font-size:13px;color:#767676;margin-top:10px;">
                    <i class="fa-solid fa-truck"></i> Despacho gratis en compras desde S/ 150.00
                </p>
            <% } %>

            <a href="pago.jsp" class="btn-primario">Continuar al pago</a>

            <div class="logos-pago" style="margin-top:18px;">
                <div class="logo-pago" style="min-width:auto;padding:7px 10px;font-size:12px;"><span class="cuadro c-bcp">BCP</span></div>
                <div class="logo-pago" style="min-width:auto;padding:7px 10px;font-size:12px;"><span class="cuadro c-bbva">BB</span></div>
                <div class="logo-pago" style="min-width:auto;padding:7px 10px;font-size:12px;"><span class="cuadro c-scotia">SB</span></div>
                <div class="logo-pago" style="min-width:auto;padding:7px 10px;font-size:12px;"><span class="cuadro c-yape">Y</span></div>
                <div class="logo-pago" style="min-width:auto;padding:7px 10px;font-size:12px;"><span class="cuadro c-plin">P</span></div>
                <div class="logo-pago" style="min-width:auto;padding:7px 10px;font-size:12px;"><span class="cuadro c-bim">B</span></div>
            </div>
        </div>
    </div>

<% } %>
</div>

<%@ include file="pie.jsp" %>
</body>
</html>
