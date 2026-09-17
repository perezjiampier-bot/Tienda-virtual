<%-- 
    Document   : pago.jsp
    Created on : 16 set. 2026, 7:59:45 p. m.
    Author     : PEREZ FFAA
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    DecimalFormat fmt = new DecimalFormat("#,##0.00");

    List<Map<String, Object>> carrito = (List<Map<String, Object>>) session.getAttribute("carrito");
    if (carrito == null || carrito.isEmpty()) {
        response.sendRedirect("carrito.jsp");
        return;
    }

    double subtotal = 0; int totalItems = 0;
    for (Map<String, Object> item : carrito) {
        subtotal += (Double) item.get("precio") * (Integer) item.get("cantidad");
        totalItems += (Integer) item.get("cantidad");
    }
    double envio = (subtotal < 150) ? 15.00 : 0.00;
    double total = subtotal + envio;
    session.setAttribute("totalPagar", total);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pago seguro | elrico.com.pe</title>
    <link rel="stylesheet" href="estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Estilos de soporte para paneles y pestañas */
        .panel-metodo { display: none; }
        .panel-metodo.activo { display: block; }
        .tab-metodo { opacity: 0.6; cursor: pointer; }
        .tab-metodo.activo { opacity: 1; border-bottom: 3px solid #28a745; font-weight: bold; }
        .opcion-banco { opacity: 0.5; cursor: pointer; border: 1px solid #ccc; background: #fff; padding: 10px; border-radius: 6px; }
        .opcion-banco.activo { opacity: 1; border-color: #28a745; background: #e8f5e9; }
        .cuadro { display: inline-block; padding: 2px 6px; border-radius: 4px; color: #fff; font-size: 11px; font-weight: bold; }
        .c-bcp { background: #002D62; }
        .c-bbva { background: #004481; }
        .c-scotia { background: #EC1C24; }
        .c-interbank { background: #00A352; }
        .c-yape { background: #7B1FA2; }
        .c-plin { background: #00BCD4; }
        .c-bim { background: #FF9800; }
        .btn-pagar-fijo { margin-top: 20px; width: 100%; background: #28a745; color: #fff; padding: 14px; border: none; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; }
        .btn-pagar-fijo:hover { background: #218838; }
    </style>
</head>
<body>

<%@ include file="cabecera.jsp" %>

<div class="pagina">
    <div class="migas"><a href="index.jsp">Inicio</a> / <a href="carrito.jsp">Mi carro</a> / Pago</div>
    <h1>Elige tu medio de pago</h1>

    <div class="aviso-demo">
        <i class="fa-solid fa-circle-info"></i>
        <b>Modo demostraci&oacute;n acad&eacute;mica:</b> esta pasarela simula el flujo de pago (validaciones en el navegador
        y confirmaci&oacute;n en el servidor). No se conecta con ning&uacute;n banco ni procesa dinero real.
    </div>

    <form id="formPago" method="post" action="confirmacion.jsp" onsubmit="return validarPago()">
        <input type="hidden" name="metodo" id="metodo" value="TARJETA">
        <input type="hidden" name="entidad" id="entidad" value="BCP">

        <div class="grid-checkout">

            <!-- ================= COLUMNA IZQUIERDA ================= -->
            <div>
                <div class="caja">
                    <h2>1. Selecciona el m&eacute;todo</h2>

                    <div class="metodos-tabs" style="display: flex; gap: 10px; margin-bottom: 20px;">
                        <button type="button" class="tab-metodo activo" id="tabTarjeta"
                                onclick="elegirMetodo('TARJETA', this)">
                            <i class="fa-regular fa-credit-card"></i> Tarjeta de cr&eacute;dito o d&eacute;bito
                        </button>
                        <button type="button" class="tab-metodo" id="tabWallet"
                                onclick="elegirMetodo('BILLETERA', this)">
                            <i class="fa-solid fa-mobile-screen-button"></i> Billetera m&oacute;vil (Yape / Plin / Bim)
                        </button>
                        <button type="button" class="tab-metodo" id="tabTransfer"
                                onclick="elegirMetodo('TRANSFERENCIA', this)">
                            <i class="fa-solid fa-building-columns"></i> Transferencia o dep&oacute;sito
                        </button>
                    </div>

                    <!-- ---------- PANEL TARJETA ---------- -->
                    <div class="panel-metodo activo" id="panelTARJETA">
                        <h2>2. Elige tu banco</h2>
                        <div class="opciones-banco-container" style="display: flex; gap: 10px; margin-bottom: 20px;">
                            <button type="button" class="opcion-banco activo" onclick="elegirEntidad('BCP', this)">
                                <span class="cuadro c-bcp">BCP</span> BCP</button>
                            <button type="button" class="opcion-banco" onclick="elegirEntidad('BBVA', this)">
                                <span class="cuadro c-bbva">BB</span> BBVA</button>
                            <button type="button" class="opcion-banco" onclick="elegirEntidad('SCOTIABANK', this)">
                                <span class="cuadro c-scotia">SB</span> Scotiabank</button>
                            <button type="button" class="opcion-banco" onclick="elegirEntidad('INTERBANK', this)">
                                <span class="cuadro c-interbank">IB</span> Interbank</button>
                        </div>

                        <h2>3. Datos de la tarjeta</h2>

                        <div class="tarjeta-visual" style="background: #1a1a1a; color: #fff; padding: 20px; border-radius: 10px; margin-bottom: 20px;">
                            <div class="chip" style="width: 40px; height: 30px; background: gold; border-radius: 4px; margin-bottom: 15px;"></div>
                            <div class="num" id="vistaNumero" style="font-size: 20px; letter-spacing: 2px; margin-bottom: 15px;">•••• •••• •••• ••••</div>
                            <div class="pie" style="display: flex; justify-content: space-between; font-size: 12px;">
                                <div>TITULAR<br><b id="vistaTitular">NOMBRE APELLIDO</b></div>
                                <div>VENCE<br><b id="vistaVence">MM/AA</b></div>
                                <div>BANCO<br><b id="vistaBanco">BCP</b></div>
                            </div>
                        </div>

                        <div class="campo" id="cNumero" style="margin-bottom: 15px;">
                            <label>N&uacute;mero de tarjeta</label><br>
                            <input type="text" id="numero" name="numero" maxlength="19" style="width: 100%; padding: 8px;"
                                   placeholder="4111 1111 1111 1111" oninput="formatearNumero()">
                        </div>

                        <div class="campo" id="cTitular" style="margin-bottom: 15px;">
                            <label>Nombre del titular</label><br>
                            <input type="text" id="titular" name="titular" placeholder="Como figura en la tarjeta" style="width: 100%; padding: 8px;"
                                   oninput="document.getElementById('vistaTitular').innerText = this.value.toUpperCase() || 'NOMBRE APELLIDO'">
                        </div>

                        <div class="fila-form" style="display: flex; gap: 10px; margin-bottom: 15px;">
                            <div class="campo" id="cVence" style="flex: 1;">
                                <label>Vencimiento (MM/AA)</label><br>
                                <input type="text" id="vence" name="vence" maxlength="5" placeholder="09/29" style="width: 100%; padding: 8px;"
                                       oninput="formatearVence()">
                            </div>
                            <div class="campo" id="cCvv" style="flex: 1;">
                                <label>CVV</label><br>
                                <input type="password" id="cvv" name="cvv" maxlength="4" placeholder="123" style="width: 100%; padding: 8px;">
                            </div>
                            <div class="campo" style="flex: 1;">
                                <label>Cuotas</label><br>
                                <select name="cuotas" id="cuotas" style="width: 100%; padding: 8px;">
                                    <option value="1">1 cuota (sin intereses)</option>
                                    <option value="3">3 cuotas</option>
                                    <option value="6">6 cuotas</option>
                                </select>
                            </div>
                        </div>

                    <!-- BOTÓN DE CONFIRMAR COMPRA CON TARJETA -->
                    <button type="submit" class="btn-pagar-fijo">
                        <i class="fa-solid fa-lock"></i> Confirmar y pagar S/ <%= fmt.format(total) %>
                    </button>
                    </div>

                    <!-- ---------- PANEL BILLETERA ---------- -->
                    <div class="panel-metodo" id="panelBILLETERA">
                        <h2>2. Elige tu billetera</h2>
                        <div class="opciones-banco-container" style="display: flex; gap: 10px; margin-bottom: 20px;">
                            <button type="button" class="opcion-banco activo" onclick="elegirEntidad('YAPE', this)">
                                <span class="cuadro c-yape">Y</span> Yape</button>
                            <button type="button" class="opcion-banco" onclick="elegirEntidad('PLIN', this)">
                                <span class="cuadro c-plin">P</span> Plin</button>
                            <button type="button" class="opcion-banco" onclick="elegirEntidad('BIM', this)">
                                <span class="cuadro c-bim">B</span> Bim</button>
                        </div>

                        <h2>3. Escanea y confirma</h2>
                        <div class="wallet-box" style="background: #fafafa; padding: 15px; border: 1px solid #ddd; border-radius: 6px;">
                        <p>Escanea el código QR desde tu app o realiza el pago móvil, luego presiona confirmar.</p>
                        <button type="submit" class="btn-pagar-fijo">
                            Ya pagué, finalizar compra
                        </button>
                    </div>
                    </div>

                    <!-- ---------- PANEL TRANSFERENCIA ---------- -->
                    <div class="panel-metodo" id="panelTRANSFERENCIA">
                        <h2>2. Datos para transferencia bancaria</h2>
                        <div class="caja" style="background: #fafafa; border: 1px dashed #ccc; padding: 15px; border-radius: 6px;">
                            <p>Realiza una transferencia directa a nuestras cuentas corrientes a nombre de <strong>El Rico S.A.C.</strong>:</p>
                            <ul>
                                <li><strong>BCP (Soles):</strong> 193-88887777-0-12</li>
                            </ul>
                        <button type="submit" class="btn-pagar-fijo">
                            Ya hice la transferencia, finalizar compra
                        </button>
                      </div>
                  </div>

                </div>
            </div>

        </form>
</div>

<script>
    // Función para cambiar entre pestañas principales (Tarjeta / Billetera / Transferencia)
    function elegirMetodo(metodo, elemento) {
        document.getElementById('metodo').value = metodo;

        // Limpiar clases activas de pestañas
        document.querySelectorAll('.tab-metodo').forEach(btn => btn.classList.remove('activo'));
        elemento.classList.add('activo');

        // Ocultar todos los paneles
        document.querySelectorAll('.panel-metodo').forEach(panel => panel.classList.remove('activo'));

        // Mostrar el panel correspondiente
        const panelActivo = document.getElementById('panel' + metodo);
        if (panelActivo) {
            panelActivo.classList.add('activo');
        }
    }

    // Función para seleccionar la entidad (Banco o Billetera)
    function elegirEntidad(entidad, elemento) {
        document.getElementById('entidad').value = entidad;

        // Encontrar el contenedor de opciones del padre actual y remover activo
        const contenedor = elemento.closest('.panel-metodo');
        if (contenedor) {
            contenedor.querySelectorAll('.opcion-banco').forEach(btn => btn.classList.remove('activo'));
        }
        elemento.classList.add('activo');

        // Actualizar visualizador de banco si aplica en tarjeta
        const vistaBanco = document.getElementById('vistaBanco');
        if (vistaBanco) {
            vistaBanco.innerText = entidad;
        }
    }

    // Formatear número de tarjeta en grupos de 4
    function formatearNumero() {
        const input = document.getElementById('numero');
        const vista = document.getElementById('vistaNumero');
        let val = input.value.replace(/\D/g, '').substring(0, 16);
        let formatted = val.match(/.{1,4}/g)?.join(' ') || '•••• •••• •••• ••••';
        input.value = formatted;
        vista.innerText = formatted;
    }

    // Formatear fecha de vencimiento MM/AA
    function formatearVence() {
        const input = document.getElementById('vence');
        const vista = document.getElementById('vistaVence');
        let val = input.value.replace(/\D/g, '').substring(0, 4);
        if (val.length >= 3) {
            val = val.substring(0, 2) + '/' + val.substring(2);
        }
        input.value = val;
        vista.innerText = val || 'MM/AA';
    }

    // Validación general antes de enviar
    function validarPago() {
        const metodo = document.getElementById('metodo').value;
        if (metodo === 'TARJETA') {
            const numero = document.getElementById('numero').value;
            if (numero.replace(/\s/g, '').length < 16) {
                alert('Por favor, ingresa un número de tarjeta válido de 16 dígitos.');
                document.getElementById('numero').focus();
                return false;
            }
        }
        return true;
    }
</script>

</body>
</html>