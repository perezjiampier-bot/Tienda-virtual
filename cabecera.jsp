<%--
    cabecera.jsp -> Header blanco (logo, menu, buscador, sesion, carrito)
    + barra secundaria (ubicacion y enlaces). Se incluye en todas las paginas.
--%>
<%@ page import="java.util.*" %>
<%
    List<Map<String, Object>> carritoCab = (List<Map<String, Object>>) session.getAttribute("carrito");
    int totalItemsCab = 0;
    if (carritoCab != null) {
        for (Map<String, Object> itCab : carritoCab) {
            totalItemsCab += (Integer) itCab.get("cantidad");
        }
    }
%>

<header class="header-principal">
    <div class="header-inner">
        <a href="index.jsp" class="logo-tienda">
            <span class="marca">elrico</span><span class="punto-com">.com.pe</span>
        </a>
        <button class="btn-menu" onclick="alert('Men\u00fa de categor\u00edas (demo)')">
            <i class="fa-solid fa-bars"></i> Men&uacute;
        </button>
        <div class="buscador">
            <input type="text" id="txtBuscar" placeholder="Buscar en elrico.com.pe"
                   onkeyup="filtrarProductos()">
            <button class="btn-lupa" onclick="filtrarProductos()">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>
        </div>
        <div class="acciones-header">
            <div class="bloque-sesion">
                <div class="saludo">Hola,</div>
                <div class="fuerte">Inicia sesi&oacute;n <i class="fa-solid fa-chevron-down"></i></div>
            </div>
            <div class="separador-vertical"></div>
            <div class="bloque-sesion"><div class="fuerte">Mi<br>cuenta</div></div>
            <div class="separador-vertical"></div>
            <div class="icono-accion"><i class="fa-regular fa-heart"></i></div>
            <a href="carrito.jsp" class="icono-accion">
                <i class="fa-solid fa-cart-shopping"></i>
                <span class="globo"><%= totalItemsCab %></span>
            </a>
        </div>
    </div>
</header>

<div class="barra-secundaria">
    <div class="sec-inner">
        <div class="ubicacion"><i class="fa-solid fa-location-dot"></i> Ingresa tu ubicaci&oacute;n</div>
        <nav>
            <a href="#">Tarjeta El Rico</a>
            <a href="#">Vende con nosotros</a>
            <a href="#">Compra por tel&eacute;fono</a>
            <a href="#">Ayuda</a>
        </nav>
    </div>
</div>
