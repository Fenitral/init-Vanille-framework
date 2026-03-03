package com.teamLead.reservationVoiture;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

    @GetMapping("/bonjour")
    public String bonjour() {
        return "Bonjour";
    }
}
