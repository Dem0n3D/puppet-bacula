define bacula::monthly_cycle(
  $title="",
  $daily_retention = "3 months",
  $monthly_retention = "2 years",
  $yearly_retention = "3 years",
  $level_y = "Full",
  $level_m = "Differential",
  $level_d = "Incremental",
  $at = '3:00'
) {
  bacula::pool { "$fqdn:pool_$title:1:daily":
    pool_type => "Backup",
    use_volume_once => "yes",
    label_format => "vol_${title}_daily.",
    volume_retention => $daily_retention,
    recycle => 'yes',
    autoprune => 'yes'
  }
  
  bacula::pool { "$fqdn:pool_$title:2:monthly":
    pool_type => "Backup",
    use_volume_once => "yes",
    label_format => "vol_${title}_monthly.",
    volume_retention => $monthly_retention,
    recycle => 'yes',
    autoprune => 'yes'
  }
  
  bacula::pool { "$fqdn:pool_$title:3:yearly":
    pool_type => "Backup",
    use_volume_once => "yes",
    label_format => "vol_${title}_yearly.",
    volume_retention => $yearly_retention,
    recycle => 'yes',
    autoprune => 'yes'
  }
  
  bacula::pool { "$fqdn:pool_$title:4:default":
    pool_type => "Backup",
    use_volume_once => "yes",
    label_format => "vol_${title}_default.",
    maximum_volumes => 100,
    recycle => 'yes',
    autoprune => 'yes'
  }

  bacula::schedule { "$fqdn:schedule_$title":
    run => [
      "Level=${level_y} Pool=$fqdn:pool_$title:3:yearly on 1 jan at $at",
      "Level=${level_m} Pool=$fqdn:pool_$title:2:monthly on 1 feb-dec at $at",
      "Level=${level_d} Pool=$fqdn:pool_$title:1:daily on 2-31 at $at"
    ]
  }
}

