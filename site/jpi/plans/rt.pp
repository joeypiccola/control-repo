plan jpi::rt (
  TargetSpec $nodes,
  Optional[String] $serial,
  Optional[String] $label_key,
  Optional[String] $label_new,
) {
    run_task('jpi::disk_set_status', $nodes, status => 'online', serial => $serial)
    run_task('jpi::volume_set_label', $nodes, label_key => $label_key, label_new => $label_new)
    run_task('jpi::disk_new_guid', $nodes, serial => $serial)
    run_task('jpi::cluster_add_disk', $nodes, name => $label_new, serial => $serial)
    #run_task('jpi::cluster_add_csv', $nodes, '_catch_errors' => true, disk_resouce_name => $new_label)

}


# re-guid task seq
#run_task('jpi::disk_set_status', $nodes, status => 'online', serial => $serial)
#run_task('jpi::disk_new_guid', $nodes, '_catch_errors' => true, serial => $serial)
#run_task('jpi::volume_set_label', $nodes, label_key => $label_key, label_new => $label_new)

# cluster task seq
#run_task('jpi::disk_set_status', $nodes, status => 'online', serial => $serial)
#run_task('jpi::cluster_add_disk', $nodes, name => $label_new, serial => $serial)
#run_task('jpi::cluster_add_csv', $nodes, '_catch_errors' => true, disk_resouce_name => $new_label)




#remove from CSV
#remove from Available Storage
#ensure offline on cluster node

# TODO need to drop driver letters when brining disks online

# # STEPS
# ## reguid server
#   1. online
#   2. re-guid
#   3. relabel
#   4. offline
#
# ## cluster node
#   1. remove previous from cluster share volume
#   2. remove previous from available storage
#   3. offline previous
#
# ## cluster node
#   1. online new
#   2. add to available storage
#   3. add to cluster shared volumes

# MOCK JSON
# [
#   {
#     "new_serial": "123",
#     "existing_label": "SHRDW101",
#     "new_label": "SHRDW2101"
#   },
#   {
#     "new_serial": "456",
#     "existing_label": "SHRDW102",
#     "new_label": "SHRDW2102"
#   },
#   {
#     "new_serial": "789",
#     "existing_label": "SHRDW103",
#     "new_label": "SHRDW2103"
#   }
# ]
