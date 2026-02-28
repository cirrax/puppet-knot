#
# class to create and execute regular backups 
# to the filesystem based on systemd timer
#
# this class is fully independent of the 
# rest of this puppet module
#
# @param dir
#   the directory where backups are saved
# @param owner
#   owner of the backup  dir
# @param group
#   group of the backup dir
# @param mode
#   mode of the backup directory
# @param timer
#   Array of lines to add to the systemd timer in the
#   timer section.
# @param list_keys_script
#   if set, a script is created there and executed which 
#   writes all current keys and their status into 
#   the file $key_stati_file
# @param key_stati_file
#   where we write the current key stati if list_keys_script
#   is set
class knot::backup (
  Stdlib::Absolutepath           $dir              = '/var/lib/knot-backup',
  String[1]                      $owner            = 'knot',
  String[1]                      $group            = 'knot',
  String[1]                      $mode             = '0700',
  Array[String[1]]               $timer            = ['OnCalendar=*-*-* 01:00:00', 'Persistent=true'],
  Optional[Stdlib::Absolutepath] $list_keys_script = undef,
  Stdlib::Absolutepath           $key_stati_file   = "${dir}/current-key-list.txt",
) {
  file { [$dir, "${dir}/current", "${dir}/previous"]:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
    mode   => $mode,
    before => Systemd::Timer['knot-backup.timer'],
  }

  if $list_keys_script {
    file { $list_keys_script :
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => 'puppet:///modules/knot/current-list-of-keys.sh',
      before => Systemd::Timer['knot-backup.timer'],
    }
  }

  systemd::timer { 'knot-backup.timer':
    ensure          => 'present',
    timer_content   => epp('knot/backup/timer.epp', { 'timer' => $timer }),
    service_content => epp('knot/backup/service.epp', { 'list_keys_script' => $list_keys_script, 'dir' => $dir, 'key_stati_file' => $key_stati_file }),
  }
}
