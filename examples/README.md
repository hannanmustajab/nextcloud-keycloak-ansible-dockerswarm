# Examples

Here an example of the integration between Nextcloud and Keycloak

## Trying it out

- `make run`
- Wait a bit
- Open Nextcloud on [http://127.0.0.1](http://127.0.0.1)
- You should be redirected to the authentication server
- Login with `vcc-examiner` and password `itsdifficult`
- You should be bought back to Nextcloud, authenticated

If you want to take a look at Keycloak and its configuration, you can find it at [http://127.0.0.1:8080](http://127.0.0.1:8080) and using `admin` as your username and password (!).

## Additional explainations

### Nextcloud Keycloak integrator

This integrator is an init container relying on Docker to run commands both inside of Nextcloud and Keycloak.

At the very beginning it simply waits until Nextcloud and Keycloak are alive and running.

Then, it creates inside of keycloak a realm (a virtual company), an OpenId Connect client for Nextcloud, and a sample user.

Finally, it configures Nextcloud for OpenId by installing an integration and changing its settings.

### Postgres

This database is configured in a single DB arragement, with both DBs being created and initialized from SQL files.

### jwt.sh

This a demo for the lesson on Single Sign On.

You need to create a client inside of keycloak, then copy its client id and secret in the settings page.
