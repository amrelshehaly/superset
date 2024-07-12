# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

RUN sudo apt-get install gcc gcc-c++ libffi-devel python3-devel python3-pip python3-wheel openssl-devel cyrus-sasl-devel openldap-devel

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Install Apache Superset
RUN pip install apache-superset

# Initialize the database
RUN superset db upgrade
RUN superset fab create-admin --username admin --firstname Superset --lastname Admin --email admin@example.com --password admin
RUN superset load_examples
RUN superset init

# Make port 8088 available to the world outside this container
EXPOSE 8088

# Define environment variable
ENV NAME World

# Run superset when the container launches
CMD ["superset", "run", "-p", "8088", "--with-threads", "--reload", "--debugger"]