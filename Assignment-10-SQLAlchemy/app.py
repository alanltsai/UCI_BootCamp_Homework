import numpy as np

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify

#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Measurement = Base.classes.measurement
Stations = Base.classes.station


# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)

#################################################
# Flask Routes
#################################################
@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        "<br/><br/>"
        f"For the following, insert dates into START and END in YYYY-MM-DD format<br/>"
        f"/api/v1.0/START<br/>"
        f"/api/v1.0/START/END"
    )


@app.route("/api/v1.0/precipitation")
def measurements():
    """Return a list of all measurments"""
    results = session.query(Measurement.date, Measurement.prcp).all()

    # Convert list of tuples into normal list
    all_measurements = list(np.ravel(results))

    return jsonify(all_measurements)

@app.route("/api/v1.0/stations")
def stations():
    """Return a list of all measurments"""
    stations = session.query(Stations.station).all()

    # Convert list of tuples into normal list
    station_names = list(np.ravel(stations))

    return jsonify(station_names)

@app.route("/api/v1.0/tobs")
def tobs():
    """Return a list of all measurments"""
    tobs = session.query(Measurement.date, Measurement.tobs).filter(Measurement.date >= "2016-08-23").all()

    # Convert list of tuples into normal list
    tobs_ytd = list(np.ravel(tobs))

    return jsonify(tobs_ytd)

@app.route("/api/v1.0/<start>")
def start_tobs(start):
    """Return a list of all measurments"""
    start_tobs = session.query(func.min(Measurement.tobs), func.max(Measurement.tobs), func.avg(Measurement.tobs)).filter(Measurement.date >= start).all()

    # Convert list of tuples into normal list
    tobs_from_start = list(np.ravel(start_tobs))

    return jsonify(tobs_from_start)

@app.route("/api/v1.0/<start>/<end>")
def start_end_tobs(start, end):
    """Return a list of all measurments"""
    start_end_tobs = session.query(func.min(Measurement.tobs), func.max(Measurement.tobs), func.avg(Measurement.tobs)).filter(Measurement.date >= start).filter(Measurement.date <=end).all()

    # Convert list of tuples into normal list
    tobs_from_start_to_end = list(np.ravel(start_end_tobs))

    return jsonify(tobs_from_start_to_end)



if __name__ == '__main__':
    app.run(debug=True)
