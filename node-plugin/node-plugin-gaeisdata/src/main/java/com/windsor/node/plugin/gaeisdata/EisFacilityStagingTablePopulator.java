package com.windsor.node.plugin.gaeisdata;

import com.windsor.node.common.domain.PluginServiceImplementorDescriptor;
import com.windsor.node.plugin.gaeisdata.dao.EisDataSourceDao;


public class EisFacilityStagingTablePopulator extends EisStagingTablePopulator {
    @Override
    protected void executeDataLoad(EisDataSourceDao sourceDao, Integer year, String facilityId) {
        sourceDao.executeFacilityDataLoad(year, facilityId);
    }

    @Override
    public PluginServiceImplementorDescriptor getPluginServiceImplementorDescription() {
        return new PluginServiceImplementorDescriptor("EisFacilityStagingTablePopulator",
                "EIS Facility Staging Table Populator for GA", "00",
                "com.windsor.node.plugin.gaeisdata.EisFacilityStagingTablePopulator");
    }
}
