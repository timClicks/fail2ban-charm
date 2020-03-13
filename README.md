# Fail2Ban

Deploys fail2ban monitoring and denial-of-service (DoS) prevention service,
with exposed configuration to help prevent SSH DoS attacks.

The fail2ban service scans log files and bans IPs that have too many password
failures.  The number of failures, and ban time are configurable.

# Deployment

The fail2ban charm is a subordinate that may be deployed against any principal charm.

    juju deploy ubuntu
    juju deploy fail2ban
    juju relate ubuntu fail2ban

These steps will install, and configure fail2ban to monitor SSH by default
with a 1 hour delay on incorrect password attempts, after 3 failed attempts.

The output of Juju status will report the "jails" that have been set up:


    ...
    Unit         Workload  Agent  Machine Public address  Ports  Message
    ubuntu/0*    active    idle   0       10.179.113.72          ready
    fail2ban/0*  active    idle           10.179.113.72          jails: ssh, sshd
    ...



# Usage

Filters are enabled with configuration parameters ending in `_filter_enabled`, 
such as `apache_filter_enabled`. Enabling filters increases security, but decreases
I/O performance. 

Each filter has a `_max_retries` parameter that sets the tolerance.

Defaults triggers are set with the following:

- `bantime` sets the number of seconds an IP address should be banned for
- `maxretry` sets the default number of permissible retries per filter
- `mta` sets the Mail Transfer Agent

The charm responds to dynamic configuration changes. For example, to increase 
the ban duration, reduce the number of permitted retries and add an internal 
CIDR block to the ignored list:

    juju config bantime=6000 ignoreip="10.0.0.0/2" maxretry=2

## Protecting SSH

To monitor SSH access attempts, set one or more of the following parameters to `True`:

- `ssh_filter_enabled` (default: `True`)
- `dropbear_filter_enabled`
- `ssh_ddos_filter_enabled`


## Protecting HTTP

The following parameters to monitor enable filters that monitor HTTP/HTTPS error logs:

- `apache_filter_enabled`
- `apache_overflows_filter_enabled`

Your web server should be configured to output files consistent with Apache httpd.


## Protecting FTP

The following parameters enable filters that monitor FTP access:

- `vsftpd_filter_enabled`
- `proftpd_filter_enabled`
- `pure_ftpd_filter_enabled`
- `wuftpd_filter_enabled`


## Protecting mail

The following parameters enable filters that monitor SMTP access:

- `postfix_filter_enabled`
- `couriersmtp_filter_enabled`
- `courierauth_filter_enabled`
- `sasl_filter_enabled`
- `dovecot_filter_enabled`

## Inspecting Configuration

To return the current configuration file that fail2ban is using, you can use
Juju to provide it to you:

    juju exec --unit fail2ban/0 'cat /etc/fail2ban/jail.local'


## Known Limitations and Issues

This charm does not allow users to specify their own filters.

The charm cannot detect the presence of applications that should be monitored. For example, it cannot relate to anything to update the filters that are applied. 


## Maintainer

- [Tim McNamara &lt;tsm@canonical.com&gt;](mailto:tsm@canonical.com)

## Fail2ban upstream project

- [Fail2ban Website](http://www.fail2ban.org/wiki/index.php/Main_Page)
- [Fail2ban issues](https://github.com/fail2ban/fail2ban/issues)
