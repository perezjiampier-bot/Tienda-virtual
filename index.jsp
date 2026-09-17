<%--
    Document   : index.jsp
    Created on : 16 set. 2026, 7:39:10 p. m.
    Author     : PEREZ FFAA
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="datos.jsp" %>
<%
    DecimalFormat fmt = new DecimalFormat("#,##0.00");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>elrico.com.pe | Agropecuaria El Rico - Tienda Online</title>
    <link rel="stylesheet" href="estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%@ include file="cabecera.jsp" %>

<!-- ================= FRANJA PROMOCIONAL ================= -->
<div class="franja-promo">
    <i class="fa-solid fa-tags"></i>
    Encuentra <strong>oportunidades &uacute;nicas</strong> | Paga con Yape, Plin, Bim o tu tarjeta
    <a href="#catalogo" class="btn-conoce">Conoce m&aacute;s</a>
</div>

<!-- ================= HERO CARRUSEL ================= -->
<section class="hero">
    <div class="hero-slide activo">
        <img src="FOTOS/1.jpg" alt="Banner 1">
        <div class="hero-texto">
            <div class="kicker">Campa&ntilde;a 2026</div>
            <h1>L&iacute;nea gen&eacute;tica de postura</h1>
            <p>Hy-Line y Lohmann con certificado sanitario y garant&iacute;a de cr&iacute;a.</p>
            <a href="#catalogo" class="btn-hero">&iexcl;VER TODO!</a>
        </div>
    </div>
    <div class="hero-slide">
        <img src="FOTOS/4.jpg" alt="Banner 2">
        <div class="hero-texto">
            <div class="kicker">Engorde</div>
            <h1>Pollos BB desde S/ 2.40</h1>
            <p>Ross 308, Cobb 500 y Arbor Acres Plus. Despacho a todo el pa&iacute;s.</p>
            <a href="#catalogo" class="btn-hero">Comprar ahora</a>
        </div>
    </div>
    <div class="hero-slide">
        <img src="FOTOS/3.jpg" alt="Banner 3">
        <div class="hero-texto">
            <div class="kicker">Pago f&aacute;cil</div>
            <h1>Yape, Plin y Bim</h1>
            <p>Tambi&eacute;n tarjetas BCP, BBVA, Scotiabank e Interbank en cuotas.</p>
            <a href="#pagos" class="btn-hero">Ver medios de pago</a>
        </div>
    </div>

    <button class="hero-flecha izq" onclick="moverHero(-1)"><i class="fa-solid fa-chevron-left"></i></button>
    <button class="hero-flecha der" onclick="moverHero(1)"><i class="fa-solid fa-chevron-right"></i></button>

    <div class="hero-puntos" id="heroPuntos">
        <span class="activo" onclick="irHero(0)"></span>
        <span onclick="irHero(1)"></span>
        <span onclick="irHero(2)"></span>
    </div>
</section>

<div class="contenedor">

    <!-- ================= CATEGORIAS CIRCULARES ================= -->
    <div class="categorias-circulos">
        <div class="cat-item"><div class="circulo"><img src="FOTOS/1.jpg" alt=""></div><span>Ponedoras</span></div>
        <div class="cat-item"><div class="circulo"><img src="FOTOS/4.jpg" alt=""></div><span>Pollos BB</span></div>
        <div class="cat-item"><div class="circulo"><img src="FOTOS/3.jpg" alt=""></div><span>Pie de cr&iacute;a</span></div>
        <div class="cat-item"><div class="circulo"><img src="FOTOS/5.jpg" alt=""></div><span>Ornamentales</span></div>
        <div class="cat-item"><div class="circulo"><img src="FOTOS/6.jpg" alt=""></div><span>Alimento</span></div>
        <div class="cat-item"><div class="circulo"><img src="FOTOS/2.jpg" alt=""></div><span>Ofertas</span></div>
    </div>

    <% if ("agregado".equals(msg)) { %>
        <div class="aviso-seguro"><i class="fa-solid fa-circle-check"></i> Producto agregado a tu carro.
            <a href="carrito.jsp" style="margin-left:8px;text-decoration:underline;font-weight:800;">Ir al carro</a></div>
    <% } %>

    <!-- ================= GRILLA DE PRODUCTOS ================= -->
    <div class="titulo-seccion" id="catalogo">
        <h2>Lo mejor de nuestro criadero</h2>
        <a href="#">Ver todo <i class="fa-solid fa-chevron-right"></i></a>
    </div>

    <div class="grilla-productos" id="grillaProductos">
    <%
        for (Map<String, Object> p : productos) {
            String id      = (String) p.get("id");
            String marca   = (String) p.get("marca");
            String nombre  = (String) p.get("nombre");
            double precio  = (Double) p.get("precio");
            double antes   = (Double) p.get("precioAntes");
            String badge   = (String) p.get("badge");
            int estrellas  = (Integer) p.get("estrellas");
            List<String> fotos = (List<String>) p.get("fotos");
    %>
        <div class="tarjeta" data-nombre="<%= nombre.toLowerCase() %> <%= marca.toLowerCase() %>">
            <span class="etiqueta-desc"><%= badge %></span>
            <button class="btn-favorito" onclick="marcarFavorito(this)"><i class="fa-regular fa-heart"></i></button>

            <div class="foto" onclick="abrirLightbox(document.getElementById('img_<%= id %>').src)">
                <img id="img_<%= id %>" src="<%= fotos.get(0) %>" alt="<%= marca %>">
            </div>

            <div class="miniaturas-tarjeta">
                <% for (int i = 0; i < fotos.size(); i++) { %>
                    <img src="<%= fotos.get(i) %>" class="<%= (i==0?"activa":"") %>"
                         onclick="cambiarFoto('<%= id %>','<%= fotos.get(i) %>', this)">
                <% } %>
            </div>

            <div class="marca-prod"><%= marca %></div>
            <div class="nombre-prod"><%= nombre %></div>

            <div class="precios">
                <div class="precio-cmr"><i class="fa-solid fa-credit-card"></i> S/ <%= fmt.format(precio * 0.95) %> con tarjeta</div>
                <span class="precio-actual">S/ <%= fmt.format(precio) %></span>
                <span class="precio-antes">Normal: S/ <%= fmt.format(antes) %></span>
            </div>

            <div class="estrellas">
                <% for (int e = 1; e <= 5; e++) { %>
                    <% if (e <= estrellas) { %><i class="fa-solid fa-star"></i><% } else { %><span><i class="fa-regular fa-star"></i></span><% } %>
                <% } %>
            </div>

            <a class="btn-agregar" href="carrito.jsp?accion=agregar&amp;id=<%= id %>&amp;volver=1"
               style="display:block;text-align:center;">
                <i class="fa-solid fa-cart-plus"></i> Agregar al carro
            </a>
        </div>
    <% } %>
    </div>

    <p id="sinResultados" style="display:none;text-align:center;color:#767676;padding:30px;">
        No encontramos productos con esa b&uacute;squeda.
    </p>

    <!-- ================= MEDIOS DE PAGO ================= -->
    <div class="bloque-pagos" id="pagos">
        <h3><i class="fa-solid fa-shield-halved"></i> Medios de pago disponibles</h3>
        <p class="sub">Paga seguro con tarjeta de tu banco o con tu billetera m&oacute;vil.</p>

        <div class="logos-pago">
            <div class="logo-pago"><span class="cuadro c-bcp">BCP</span> Banco de Cr&eacute;dito</div>
            <div class="logo-pago"><span class="cuadro c-bbva">BB</span> BBVA</div>
            <div class="logo-pago"><span class="cuadro c-scotia">SB</span> Scotiabank</div>
            <div class="logo-pago"><span class="cuadro c-interbank">IB</span> Interbank</div>
            <div class="logo-pago"><span class="cuadro c-yape">Y</span> Yape</div>
            <div class="logo-pago"><span class="cuadro c-plin">P</span> Plin</div>
            <div class="logo-pago"><span class="cuadro c-bim">B</span> Bim</div>
        </div>
    </div>

</div>

<!-- ================= LIGHTBOX ================= -->
<div id="miLightbox" class="lightbox" onclick="cerrarLightbox()">
    <span class="cerrar">&times;</span>
    <img id="imgLightbox" src="" alt="">
</div>

<%@ include file="pie.jsp" %>

<script src="script.js"></script>

</body>
</html>