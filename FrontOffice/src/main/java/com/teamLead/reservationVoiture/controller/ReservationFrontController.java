package com.teamLead.reservationVoiture.controller;

import com.teamLead.reservationVoiture.dto.ReservationDto;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/front")
public class ReservationFrontController {

    private final String apiUrl;
    private final RestTemplate restTemplate = new RestTemplate();

    public ReservationFrontController(@Value("${external.api.reservations.url:http://localhost:8080/test/api/reservation/list}") String apiUrl) {
        this.apiUrl = apiUrl;
    }

    @GetMapping("/reservations")
    public String listReservations(
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to,
            Model model
    ) {
        List<ReservationDto> reservations = fetchReservations();

        DateTimeFormatter fmt = DateTimeFormatter.ISO_LOCAL_DATE;
        if (date != null && !date.isEmpty()) {
            LocalDate d = LocalDate.parse(date, fmt);
            reservations = reservations.stream()
                    .filter(r -> d.equals(r.getArrivalDate()))
                    .collect(Collectors.toList());
        } else if ((from != null && !from.isEmpty()) || (to != null && !to.isEmpty())) {
            LocalDate f = (from != null && !from.isEmpty()) ? LocalDate.parse(from, fmt) : LocalDate.MIN;
            LocalDate t = (to != null && !to.isEmpty()) ? LocalDate.parse(to, fmt) : LocalDate.MAX;
            reservations = reservations.stream()
                    .filter(r -> r.getArrivalDate() != null && !r.getArrivalDate().isBefore(f) && !r.getArrivalDate().isAfter(t))
                    .collect(Collectors.toList());
        }

        model.addAttribute("reservations", reservations);
        return "reservations";
    }

    private List<ReservationDto> fetchReservations() {
        try {
            // Call the API and handle wrapped responses like {"status":..., "data": [...]}
            String json = restTemplate.getForObject(apiUrl, String.class);
            if (json == null || json.isBlank()) {
                return Collections.emptyList();
            }

            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            com.fasterxml.jackson.databind.JsonNode root = mapper.readTree(json);

            com.fasterxml.jackson.databind.JsonNode arrayNode = root;
            if (root.has("data") && root.get("data").isArray()) {
                arrayNode = root.get("data");
            } else if (root.has("reservations") && root.get("reservations").isArray()) {
                arrayNode = root.get("reservations");
            }

            if (!arrayNode.isArray()) {
                return Collections.emptyList();
            }

            List<ReservationDto> list = new java.util.ArrayList<>();
            for (com.fasterxml.jackson.databind.JsonNode node : arrayNode) {
                ReservationDto dto = new ReservationDto();
                // id can be named idReservation or id
                if (node.has("idReservation")) dto.setId(node.path("idReservation").asLong());
                else if (node.has("id")) dto.setId(node.path("id").asLong());

                // customer name may be idClient or customerName
                if (node.has("idClient")) dto.setCustomerName(node.path("idClient").asText());
                else dto.setCustomerName(node.path("customerName").asText(null));

                // hotel name may be nested
                if (node.has("hotel") && node.get("hotel").has("nom")) {
                    dto.setHotelName(node.get("hotel").path("nom").asText());
                } else {
                    dto.setHotelName(node.path("hotelName").asText(null));
                }

                // arrival date: dateHeureArrive like 2026-02-06T18:35 -> take date part
                if (node.has("dateHeureArrive")) {
                    String s = node.path("dateHeureArrive").asText(null);
                    if (s != null && s.length() >= 10) {
                        dto.setArrivalDate(LocalDate.parse(s.substring(0, 10)));
                    }
                } else if (node.has("arrivalDate")) {
                    String s = node.path("arrivalDate").asText(null);
                    if (s != null && s.length() >= 10) dto.setArrivalDate(LocalDate.parse(s.substring(0, 10)));
                }

                list.add(dto);
            }

            return list;
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }
}
