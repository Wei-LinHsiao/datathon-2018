import csv


def file_to_dict(filename):
    return_dict = {}

    with open(filename, 'r') as csvfile:
        data = csv.reader(csvfile, delimiter=',')
        for row in data:
            key_full = row[0]
            key_actual = ""

            begin = True
            for letter in key_full:
                if letter != "0":
                    begin = False
                if not begin:
                    key_actual = key_actual + letter


            return_dict[key_actual] = row[1]

    return return_dict

def key_to_actual(key, dict):
    if key in dict:
        return dict[key]
    else:
        return "ERROR: KEY NOT FOUND"


agency = file_to_dict("agencyID.csv")
permit_stat = file_to_dict("permitStatus.csv")
permit_type = file_to_dict("permitType.csv")
property_type = file_to_dict("propertyType.csv")
state_class = file_to_dict("stateClass.csv")


with open("maindata.csv", 'rb') as input_data:
    with open("newdata.csv", "wb+") as output_data:
        input = csv.reader(input_data, delimiter=',')
        output = csv.writer(output_data)

        first = True

        for row in input:
            if first:
                print row
                output.writerow(row)
                first = False

            """['account', 'permitID', 'agencyID', 'permitStatus', 'desc', 'stateClass', 'permitType', 'propertyType', 
            'issueDate', 'year', 'siteNo', 'sitePrefix', 'siteStreet', 'siteType', 'siteSuffix', 'siteApt']"""


            row[3] = key_to_actual(row[3], agency)
            row[4] = key_to_actual(row[4], permit_stat)
            row[7] = key_to_actual(row[7], permit_type)
            row[8] = key_to_actual(row[8], property_type)
            row[6] = key_to_actual(row[6], state_class)

            output.writerow(row)
