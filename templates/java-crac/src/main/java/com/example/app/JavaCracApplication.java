package com.example.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.crac.Resource;
import org.crac.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SpringBootApplication
public class JavaCracApplication implements Resource {
    private static final Logger logger = LoggerFactory.getLogger(JavaCracApplication.class);
    
    public static void main(String[] args) {
        // Register CRaC resource before starting
        Context<Resource> ctx = org.crac.Core.getContext();
        ctx.register(new JavaCracApplication());
        
        SpringApplication.run(JavaCracApplication.class, args);
    }
    
    @Override
    public void beforeCheckpoint(org.crac.CheckpointException e) throws Exception {
        logger.info("CRaC: Before checkpoint - preparing for restore");
    }
    
    @Override
    public void afterRestore(org.crac.CheckpointException e) throws Exception {
        logger.info("CRaC: After restore - application restored from checkpoint");
    }
}
