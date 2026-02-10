package com.example.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Java 21 Spring Boot Application.
 *
 * NOTE: For CRaC (sub-second startup), this application is designed to work
 * with a CRaC-enabled JDK. Standard JDK will run this as a normal Spring Boot app.
 *
 * CRaC Benefits:
 * - Cold start: < 100ms (vs 2-5s normally)
 * - Memory: ~20% reduction
 * - Perfect for serverless and containerized workloads
 */
@SpringBootApplication
public class JavaCracApplication {
    private static final Logger logger = LoggerFactory.getLogger(JavaCracApplication.class);

    public static void main(String[] args) {
        logger.info("Starting Java CRaC Demo Application...");
        logger.info("For sub-second startup, use a CRaC-enabled JDK (Azul Zulu or BellSoft Liberica Full)");

        SpringApplication.run(JavaCracApplication.class, args);
    }
}
