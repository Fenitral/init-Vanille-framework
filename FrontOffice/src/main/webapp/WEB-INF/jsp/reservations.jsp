<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List, com.teamLead.reservationVoiture.dto.ReservationDto" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Liste des réservations</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background: #f2f2f2; }
    </style>
</head>
<body>
<h1>Liste des réservations</h1>

<form method="get" action="${pageContext.request.contextPath}/front/reservations">
    <label>Date (exacte): <input type="date" name="date" /></label>
    &nbsp;ou&nbsp;
    <label>Du: <input type="date" name="from" /></label>
    <label>Au: <input type="date" name="to" /></label>
    <button type="submit">Filtrer</button>
</form>

<br/>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Client</th>
        <th>Hôtel</th>
        <th>Date d'arrivée</th>
    </tr>
    </thead>
    <tbody>
    <%
        List<ReservationDto> list = (List<ReservationDto>) request.getAttribute("reservations");
        if (list != null && !list.isEmpty()) {
            for (ReservationDto r : list) {
    %>
        <tr>
            <td><%= r.getId() %></td>
            <td><%= r.getCustomerName() %></td>
            <td><%= r.getHotelName() %></td>
            <td><%= r.getArrivalDate() %></td>
        </tr>
    <%      }
        } else { %>
        <tr>
            <td colspan="4">Aucune réservation trouvée.</td>
        </tr>
    <% } %>
    </tbody>
</table>

</body>
</html>
