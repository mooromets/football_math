#include <string>

//very plain SQL statement builder

class sqlStatement {
public:
	sqlStatement(const std::string& str = "") : _data(str) {}

	const char* c_str() const {
		return _data.c_str();
	}

	sqlStatement& select(const std::string& str) { return add("SELECT", str); }
	sqlStatement& from(const std::string& str) { return add("\n\tFROM", str); }
	sqlStatement& where(const std::string& str) { return add("\n\tWHERE", str); }
	sqlStatement& union_(const std::string& str = "") { return add("\n\tUNION", ""); }
	sqlStatement& order(const std::string& str) { return add("\n\tORDER BY", str); }
	sqlStatement& group(const std::string& str) { return add("\n\tGROUP BY", str); }

protected:
	sqlStatement& add(const std::string& keyWord, const std::string& str){
		_data.append(" ").append(keyWord).append(" ").append(str).append(" ");
		return *this;
	}

private:
	std::string _data;
};
