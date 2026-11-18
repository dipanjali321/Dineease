package com.jobscheduler.dineease.config;

import java.util.List;

import com.jobscheduler.dineease.repository.AppUserRepository;
import com.jobscheduler.dineease.service.DatabaseUserDetailsService;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService(
            PasswordEncoder passwordEncoder,
            AppUserRepository appUserRepository,
            @Value("${dineease.admin.password:}") String adminPassword) {

        if (adminPassword == null || adminPassword.isBlank()) {
            throw new IllegalStateException(
                    "DINEEASE_ADMIN_PASSWORD environment variable is missing");
        }

        UserDetails admin = User.builder()
                .username("admin")
                .password(passwordEncoder.encode(adminPassword))
                .roles("ADMIN")
                .build();

        UserDetailsService adminUsers =
                new InMemoryUserDetailsManager(admin);

        // Create the database-backed service without registering
        // another UserDetailsService bean.
        DatabaseUserDetailsService databaseUserDetailsService =
                new DatabaseUserDetailsService(appUserRepository);

        // Route admin authentication to the in-memory admin user.
        // All other usernames are checked against the database.
        return username -> {
            if ("admin".equals(username)) {
                return adminUsers.loadUserByUsername(username);
            }

            return databaseUserDetailsService.loadUserByUsername(username);
        };
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http)
            throws Exception {

        http
                .cors(Customizer.withDefaults())
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(HttpMethod.GET, "/api/restaurants").permitAll()
                        .requestMatchers(
                                HttpMethod.GET,
                                "/api/menu",
                                "/api/menu/**"
                        ).permitAll()
                        .requestMatchers(
                                HttpMethod.POST,
                                "/api/orders"
                        ).permitAll()
                        .requestMatchers(
                                HttpMethod.POST,
                                "/api/customer/auth/request-otp",
                                "/api/customer/auth/verify-otp",
                                "/api/customer/auth/logout"
                        ).permitAll()
                        .requestMatchers(
                                HttpMethod.GET,
                                "/api/customer/orders",
                                "/api/customer/orders/*"
                        ).permitAll()
// Restaurant partners can access partner endpoints.
                        .requestMatchers("/api/partner/**")
                        .hasRole("RESTAURANT_PARTNER")

                        // All other protected endpoints remain admin-only.
                        .anyRequest().hasRole("ADMIN")
                )
                .httpBasic(Customizer.withDefaults());

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        configuration.setAllowedOrigins(
        List.of(
                "http://localhost:5173",
                "http://localhost:5174",
                "https://dineease-blue.vercel.app",
                "https://dineease-3qq6qd7cb-dipanjalibhujbal-2710s-projects.vercel.app"
        )
);

        configuration.setAllowedMethods(
                List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
        );

        configuration.setAllowedHeaders(
                List.of(
                        "Content-Type",
                        "Authorization",
                        "Accept",
                        "X-Customer-Session"
                )
        );

        UrlBasedCorsConfigurationSource source =
                new UrlBasedCorsConfigurationSource();

        source.registerCorsConfiguration("/**", configuration);

        return source;
    }
}
