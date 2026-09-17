/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
/* ==========================================================================
   script.js -> Interactividad de la tienda El Rico (portada index.jsp)
   ========================================================================== */

/* ---------- CARRUSEL DEL BANNER ---------- */
var slideActual = 0;
var slides = document.querySelectorAll('.hero-slide');
var puntos = document.querySelectorAll('#heroPuntos span');

function mostrarHero(i) {
    if (slides.length > 0 && puntos.length > 0) {
        slides.forEach(function (s) { s.classList.remove('activo'); });
        puntos.forEach(function (p) { p.classList.remove('activo'); });
        slides[i].classList.add('activo');
        puntos[i].classList.add('activo');
        slideActual = i;
    }
}
function moverHero(dir) {
    if (slides.length > 0) {
        var nuevo = slideActual + dir;
        if (nuevo >= slides.length) nuevo = 0;
        if (nuevo < 0) nuevo = slides.length - 1;
        mostrarHero(nuevo);
    }
}
function irHero(i) { mostrarHero(i); }

// Solo activa el intervalo si existen slides en la página actual
if (slides.length > 0) {
    setInterval(function () { moverHero(1); }, 6000);
}

/* ---------- MINIATURAS DE CADA TARJETA ---------- */
function cambiarFoto(id, ruta, elemento) {
    var imgPrincipal = document.getElementById('img_' + id);
    if (imgPrincipal) {
        imgPrincipal.src = ruta;
        var hermanas = elemento.parentNode.querySelectorAll('img');
        hermanas.forEach(function (h) { h.classList.remove('activa'); });
        elemento.classList.add('activa');
    }
}

/* ---------- FAVORITOS ---------- */
function marcarFavorito(btn) {
    btn.classList.toggle('activo');
    var ico = btn.querySelector('i');
    if (ico) {
        ico.classList.toggle('fa-regular');
        ico.classList.toggle('fa-solid');
    }
}

/* ---------- BUSCADOR ---------- */
function filtrarProductos() {
    var inputBuscar = document.getElementById('txtBuscar');
    var grilla = document.getElementById('grillaProductos');
    var sinRes = document.getElementById('sinResultados');
    
    if (inputBuscar && grilla) {
        var texto = inputBuscar.value.toLowerCase().trim();
        var tarjetas = grilla.querySelectorAll('.tarjeta');
        var visibles = 0;
        tarjetas.forEach(function (t) {
            var dataNombre = t.getAttribute('data-nombre') || '';
            var coincide = dataNombre.indexOf(texto) !== -1;
            t.style.display = coincide ? 'flex' : 'none';
            if (coincide) visibles++;
        });
        if (sinRes) {
            sinRes.style.display = (visibles === 0) ? 'block' : 'none';
        }
    }
}

/* ---------- LIGHTBOX (zoom de fotos) ---------- */
function abrirLightbox(src) {
    var imgLightbox = document.getElementById('imgLightbox');
    var miLightbox = document.getElementById('miLightbox');
    if (imgLightbox && miLightbox) {
        imgLightbox.src = src;
        miLightbox.style.display = 'flex';
    }
}
function cerrarLightbox() {
    var miLightbox = document.getElementById('miLightbox');
    if (miLightbox) {
        miLightbox.style.display = 'none';
    }
}

/* ---------- PASARELA DE PAGOS: BILLETERAS DIGITALES (YAPE, PLIN, BIM) ---------- */

// Función para alternar la billetera activa y actualizar la interfaz dinámicamente
function elegirWallet(walletName, elemento) {
    // 1. Remover la clase 'activo' de todos los botones de billetera
    const botones = document.querySelectorAll('.opcion-banco');
    botones.forEach(btn => btn.classList.remove('activo'));

    // 2. Añadir la clase 'activo' al botón presionado
    if (elemento) {
        elemento.classList.add('activo');
    }

    // 3. Actualizar la sección de "Escanea y confirma" según la billetera elegida
    const walletBox = document.querySelector('.wallet-box');
    if (walletBox) {
        let colorFondo = '#742284'; // Morado por defecto (Yape)
        let logoTexto = 'YAPE';
        
        if (walletName === 'PLIN') {
            colorFondo = '#00A19B'; // Turquesa Plin
            logoTexto = 'PLIN';
        } else if (walletName === 'BIM') {
            colorFondo = '#F7941D'; // Naranja Bim
            logoTexto = 'BIM';
        }

        // Generar dinámicamente el contenido QR con diseño realista
        walletBox.innerHTML = `
            <div style="text-align: center; padding: 15px;">
                <p style="font-weight: bold; color: ${colorFondo}; margin-bottom: 10px;">Escanea con tu aplicación de ${logoTexto}</p>
                <div style="background: #f0f0f0; padding: 15px; display: inline-block; border-radius: 8px; border: 2px dashed ${colorFondo};">
                    <div style="width: 140px; height: 140px; background: #222; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: bold; border-radius: 4px;">
                        [ QR ${logoTexto} ]
                    </div>
                </div>
                <p style="font-size: 13px; color: #444; margin-top: 10px;">Número receptor: <strong>999-888-777</strong></p>
                <p style="font-size: 11px; color: #777; margin-bottom: 12px;">Titular: Tienda Virtual S.A.C.</p>
                <button type="button" onclick="confirmarPagoWallet('${logoTexto}')" style="background: ${colorFondo}; color: #ffffff; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 14px; box-shadow: 0 3px 6px rgba(0,0,0,0.2);">
                    Ya pagué con ${logoTexto}
                </button>
            </div>
        `;
    }
}

// Simulación de validación y éxito del pago
function confirmarPagoWallet(wallet) {
    // Alerta visual simulando el procesamiento y confirmación de la pasarela
    alert(`¡Pago verificado con éxito a través de ${wallet}! Gracias por tu compra.`);
    
    // Opcional: Redirigir o limpiar el carrito al confirmar
    // window.location.href = "gracias.jsp";
}
