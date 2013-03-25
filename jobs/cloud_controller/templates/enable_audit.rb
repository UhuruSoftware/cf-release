#!/usr/bin/ruby

require 'pg'

config ||= {}

config['ccdb'] =
    {
        'host' => ARGV[0],
        'port' => ARGV[1],
        'dbname' => ARGV[2],
        'user' => ARGV[3],
        'password' => ARGV[4],
    }


pg_conn = PG.connect(
    host: config['ccdb']['host'],
    port: config['ccdb']['port'],
    dbname: config['ccdb']['dbname'],
    user: config['ccdb']['user'],
    password: config['ccdb']['password'],
)

pg_conn.exec("SELECT audit.audit_table('users');")
pg_conn.exec("SELECT audit.audit_table('apps');")
pg_conn.exec("SELECT audit.audit_table('services');")
pg_conn.exec("SELECT audit.audit_table('service_configs');")

