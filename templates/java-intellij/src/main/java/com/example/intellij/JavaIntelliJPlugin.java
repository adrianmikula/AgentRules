package com.example.intellij;

import com.intellij.openapi.extensions.PluginId;
import com.intellij.openapi.plugin.Plugin;
import com.intellij.openapi.plugin.PluginManager;
import com.intellij.openapi.project.Project;

/**
 * IntelliJ Plugin - Main Plugin Class
 * Optimized for fast development with IntelliJ Test Framework
 */
public class JavaIntelliJPlugin implements Plugin {
    
    private final PluginId id;
    private final String name;
    private final String version;
    
    public JavaIntelliJPlugin() {
        this.id = PluginId.getId("com.example.intellij");
        this.name = "Java IntelliJ Plugin";
        this.version = "1.0.0";
    }
    
    @Override
    public PluginId getId() {
        return id;
    }
    
    @Override
    public String getName() {
        return name;
    }
    
    @Override
    public String getVersion() {
        return version;
    }
    
    /**
     * Initialize the plugin
     */
    public void initialize() {
        System.out.println("Initializing " + getName() + " v" + getVersion());
    }
    
    /**
     * Get plugin instance
     */
    public static JavaIntelliJPlugin getInstance() {
        Plugin plugin = PluginManager.getPlugin(id);
        return (JavaIntelliJPlugin) plugin;
    }
}
