define bacula::weekly_cycle(
  $title="",
  $daily_retention = "1 months",
  $weekly_retention = "1 years",
  $monthly_retention = "3 years",
  $level_m = "Full",
  $level_w = "Differential",
  $level_d = "Incremental",
  $at = '1:00'
) {
  bacula::pool { "$fqdn:pool_$title:1:daily":
    pool_type => "Backup",
    use_volume_once => "yes",
    label_format => "vol_${title}_daily.",
    volume_retention => $daily_retention,
    recycle => 'yes',
    autoprune => 'yes'
  }
  
  bacula::pool { "$fqdn:pool_$title:2:weekly":
    pool_type => "Backup",
    use_volume_once => "yes",
    label_format => "vol_${title}_weekly.",
    volume_retention => $weekly_retention,
    recycle => 'yes',
    autoprune => 'yes'
  }
  
  bacula::pool { "$fqdn:pool_$title:3:monthly":
    pool_type => "Backup",
    use_volume_once => "yes",
    label_format => "vol_${title}_monthly.",
    volume_retention => $monthly_retention,
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
      "Level=${level_m} Pool=$fqdn:pool_$title:3:monthly 1st sun at $at",
      "Level=${level_w} Pool=$fqdn:pool_$title:2:weekly 2nd-5th sun at $at",
      "Level=${level_d} Pool=$fqdn:pool_$title:1:daily mon-sat at $at"
    ]
  }
}

