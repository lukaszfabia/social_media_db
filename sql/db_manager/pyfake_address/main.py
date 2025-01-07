import requests
import time
import csv
import random


def fetch_addresses(city, limit=5):
    """
    Fetch addresses with detailed components for a given city using the Nominatim API.
    """
    url = "https://nominatim.openstreetmap.org/search"
    params = {
        "q": city,
        "format": "json",
        "limit": limit,
        "addressdetails": 1  # Request detailed address breakdown
    }

    try:
        response = requests.get(url, params=params, headers={
                                "User-Agent": "address-fetcher-script"})
        response.raise_for_status()
        results = response.json()

        addresses = []
        for res in results:
            address = res.get("address", {})
            # Extract data with fallbacks
            street_name = address.get("road") or address.get(
                "suburb") or address.get("neighbourhood", "")
            building = address.get("house_number", "")

            # Skip entries without street names
            if not street_name:
                # generate random street name
                street_name = f"Street {random.randint(1, 100)}"

            # Generate random plausible numbers if missing
            gate = address.get("gate", str(random.randint(1, 10)))
            floor = address.get("floor", str(random.randint(0, 20)))
            apartment = address.get("apartment", str(random.randint(1, 100)))

            addresses.append({
                "latitude": res.get("lat"),
                "longitude": res.get("lon"),
                "street_name": street_name,
                "building": building,
                "city": address.get("city", address.get("town", address.get("village", ""))),
                "country": address.get("country", ""),
                "postal_code": address.get("postcode", ""),
                "gate": gate,
                "floor": floor,
                "apartment": apartment
            })
        return addresses
    except Exception as e:
        print(f"Error fetching addresses for {city}: {e}")
        return []


def main() -> None:
    # List of cities to query without specific streets
    cities: list[str] = [
        "New York, United States",
        "Los Angeles, United States",
        "Chicago, United States",
        "Toronto, Canada",
        "Vancouver, Canada",
        "Mexico City, Mexico",
        "Monterrey, Mexico",
        "São Paulo, Brazil",
        "Rio de Janeiro, Brazil",
        "Buenos Aires, Argentina",
        "Lima, Peru",
        "Bogotá, Colombia",
        "Santiago, Chile",
        "London, United Kingdom",
        "Paris, France",
        "Berlin, Germany",
        "Rome, Italy",
        "Madrid, Spain",
        "Amsterdam, Netherlands",
        "Warsaw, Poland",
        "Vienna, Austria",
        "Stockholm, Sweden",
        "Prague, Czech Republic",
        "Dublin, Ireland",
        "Tokyo, Japan",
        "Osaka, Japan",
        "Seoul, South Korea",
        "Beijing, China",
        "Shanghai, China",
        "Bangkok, Thailand",
        "Jakarta, Indonesia",
        "Kuala Lumpur, Malaysia",
        "Manila, Philippines",
        "Mumbai, India",
        "New Delhi, India",
        "Cairo, Egypt",
        "Lagos, Nigeria",
        "Nairobi, Kenya",
        "Cape Town, South Africa",
        "Johannesburg, South Africa",
        "Casablanca, Morocco",
        "Accra, Ghana",
        "Sydney, Australia",
        "Melbourne, Australia",
        "Auckland, New Zealand",
        "Wellington, New Zealand"
    ]

    all_addresses = []

    for city in cities:
        print(f"Fetching addresses for: {city}")
        addresses = fetch_addresses(city, limit=5)
        if not addresses:
            print("No addresses found.")
        all_addresses.extend(addresses)
        time.sleep(1)  # Avoid rate limiting

    # Save collected addresses to CSV
    with open("formatted_addresses.csv", "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["Latitude", "Longitude", "StreetName", "Building", "City",
                         "Country", "PostalCode", "Gate", "Floor", "Apartment"])

        for address in all_addresses:
            writer.writerow([
                address["latitude"],
                address["longitude"],
                address["street_name"],
                address["building"],
                address["city"],
                address["country"],
                address["postal_code"],
                address["gate"],
                address["floor"],
                address["apartment"]
            ])

    print(f"\nTotal addresses collected and saved: {len(all_addresses)}")


if __name__ == "__main__":
    main()
