package com.windsor.node.plugin.common;

import com.windsor.node.common.PluginMetaDataFactory;
import com.windsor.node.common.domain.PluginMetaData;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PluginMetaDataFactoryImpl implements PluginMetaDataFactory {
   protected final Logger logger = LoggerFactory.getLogger(PluginMetaDataFactoryImpl.class);

   public PluginMetaData createPluginMetaData() {
      PluginMetaData pluginMetaData = new PluginMetaData();
      Properties props = new Properties();

      try {
         props.load(PluginMetaDataFactoryImpl.class.getClassLoader().getResourceAsStream("plugin-data.properties"));
      } catch (Exception var4) {
         this.logger.error("Unable to load properties for PluginMetaData due to Exception, recovering but some functionality may be unavailable.", var4);
      }

      pluginMetaData.setName(props.getProperty("name"));
      pluginMetaData.setFullName(props.getProperty("full.name"));
      pluginMetaData.setDescription(props.getProperty("description"));
      pluginMetaData.setVersion(props.getProperty("version"));
      pluginMetaData.setHelpText(props.getProperty("help.text"));
      return pluginMetaData;
   }
}
