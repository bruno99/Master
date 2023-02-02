CREATE KEYSPACE vayahoteles
    WITH replication = {
      'class': 'SimpleStrategy',
      'replication_factor': 3
};
 
CREATE TABLE vayahoteles.hoteles (
  hotel_id text,
  nombre text,
  telefono text,
  direccion text,
  sitio_web text,
  email_reserva text,
  PRIMARY KEY (hotel_id)
);
 
CREATE TABLE vayahoteles.hoteles_por_pdi (
  nombre_pdi text,
  hotel_id text,
  nombre text,
  telefono text,
  direccion text,
  PRIMARY KEY ((nombre_pdi), hotel_id)
) WITH CLUSTERING ORDER BY (hotel_id ASC);
 
CREATE TABLE vayahoteles.habitaciones_disponibles_por_fecha_y_hotel (
  hotel_id text,
  fecha timestamp,
  numero_habitacion int,
  direccion text,
  es_disponible boolean,
  PRIMARY KEY ((hotel_id), fecha, numero_habitacion)
) WITH CLUSTERING ORDER BY (fecha ASC, numero_habitacion ASC);
 
CREATE TABLE vayahoteles.pdi_por_hotel (
  hotel_id text,
  nombre_pdi text,
  descripcion text,
  geo_localizacion text,
  PRIMARY KEY ((hotel_id), nombre_pdi)
) WITH CLUSTERING ORDER BY (nombre_pdi ASC);
 
CREATE TABLE vayahoteles.complementos_por_habitacion (
  hotel_id text,
  numero_habitacion int,
  nombre text,
  descripcion text,
  PRIMARY KEY ((hotel_id, numero_habitacion), nombre)
) WITH CLUSTERING ORDER BY (nombre ASC);

CREATE TABLE vayahoteles.reservas_por_n (
   n_confirmacion text,
   id_huesped text,
   n_habitacion int,
   id_hotel text,
   fecha_entrada timestamp,
   fecha_salida timestamp,
   PRIMARY KEY (n_confirmacion)
);

CREATE TABLE vayahoteles.reservas_por_h_f_n (
   n_confirmacion text,
   id_huesped text,
   nombre text,
   apellidos text,
   email text,
   telefono text,
   direccion text,
   n_habitacion int,
   id_hotel text,
   fecha_entrada timestamp,
   fecha_salida timestamp,
   PRIMARY KEY (id_hotel, fecha_entrada, id_huesped)
);

CREATE TABLE vayahoteles.huespedes (
   id_huesped text,
   nombre text,
   apellidos text,
   email text,
   telefono text,
   direccion text,   
   PRIMARY KEY (id_huesped)
);
