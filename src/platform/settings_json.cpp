//-----------------------------------------------------------------------------
// The GTK-based implementation of platform-dependent GUI functionality.
//
// Copyright 2018 whitequark
//-----------------------------------------------------------------------------
#include <errno.h>
#include <sys/stat.h>
#include <unistd.h>
#include <json-c/json_object.h>
#include <json-c/json_util.h>

#include "solvespace.h"

#include "settings_json.h"

namespace SolveSpace {
namespace Platform {


SettingsJsonStore::SettingsJsonStore(std::string jsonpath) {
    _path = Path::From(path.raw);
    if(_path.IsEmpty()) {
        dbp("settings will not be saved");
    } else {
        _json = json_object_from_file(_path.raw.c_str());
        if(!_json && errno != ENOENT) {
            dbp("cannot load settings: %s", strerror(errno));
        }
    }

    if(_json == NULL) {
        _json = json_object_new_object();
    }
}

SettingsJsonStore::~SettingsJsonStore() {
    if(!_path.IsEmpty()) {
        // json-c <0.12 has the first argument non-const
        if(json_object_to_file_ext((char *)_path.raw.c_str(), _json,
                                    JSON_C_TO_STRING_PRETTY)) {
            dbp("cannot save settings: %s", strerror(errno));
        }
    }

    json_object_put(_json);
}

void SettingsJsonStore::FreezeInt(const std::string &key, uint32_t value) override {
    struct json_object *jsonValue = json_object_new_int(value);
    json_object_object_add(_json, key.c_str(), jsonValue);
}

uint32_t SettingsJsonStore::ThawInt(const std::string &key, uint32_t defaultValue) override {
    struct json_object *jsonValue;
    if(json_object_object_get_ex(_json, key.c_str(), &jsonValue)) {
        return json_object_get_int(jsonValue);
    }
    return defaultValue;
}

void SettingsJsonStore::FreezeBool(const std::string &key, bool value) override {
    struct json_object *jsonValue = json_object_new_boolean(value);
    json_object_object_add(_json, key.c_str(), jsonValue);
}

bool SettingsJsonStore::ThawBool(const std::string &key, bool defaultValue) override {
    struct json_object *jsonValue;
    if(json_object_object_get_ex(_json, key.c_str(), &jsonValue)) {
        return json_object_get_boolean(jsonValue);
    }
    return defaultValue;
}

void SettingsJsonStore::FreezeFloat(const std::string &key, double value) override {
    struct json_object *jsonValue = json_object_new_double(value);
    json_object_object_add(_json, key.c_str(), jsonValue);
}

double SettingsJsonStore::ThawFloat(const std::string &key, double defaultValue) override {
    struct json_object *jsonValue;
    if(json_object_object_get_ex(_json, key.c_str(), &jsonValue)) {
        return json_object_get_double(jsonValue);
    }
    return defaultValue;
}

void SettingsJsonStore::FreezeString(const std::string &key, const std::string &value) override {
    struct json_object *jsonValue = json_object_new_string(value.c_str());
    json_object_object_add(_json, key.c_str(), jsonValue);
}

std::string SettingsJsonStore::ThawString(const std::string &key,
                        const std::string &defaultValue = "") override {
    struct json_object *jsonValue;
    if(json_object_object_get_ex(_json, key.c_str(), &jsonValue)) {
        return json_object_get_string(jsonValue);
    }
    return defaultValue;
}

};
}
}
