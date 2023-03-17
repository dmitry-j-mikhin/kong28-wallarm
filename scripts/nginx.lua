return [[
pid pids/nginx.pid;
error_log ${{PROXY_ERROR_LOG}} ${{LOG_LEVEL}};

# injected nginx_main_* directives
> for _, el in ipairs(nginx_main_directives) do
$(el.name) $(el.value);
> end

load_module /opt/wallarm/modules/kong/ngx_http_wallarm_module.so;

events {
    # injected nginx_events_* directives
> for _, el in ipairs(nginx_events_directives) do
    $(el.name) $(el.value);
> end
}

> if role == "control_plane" or #proxy_listeners > 0 or #admin_listeners > 0 or #status_listeners > 0 then
http {
    server {
      listen 127.0.0.8:80;

      server_name localhost;

      allow 127.0.0.0/8;
      deny all;

      wallarm_mode off;
      disable_acl "on";
      access_log off;

      location ~/wallarm-status$ {
        wallarm_status on;
      }
    }
    disable_acl "on";
    include 'nginx-kong.conf';
}
> end

> if #stream_listeners > 0 then
stream {
    include 'nginx-kong-stream.conf';
}
> end
]]
