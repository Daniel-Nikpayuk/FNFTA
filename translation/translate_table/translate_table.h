/*************************************************************************************************************************
**
** Copyright 2015 Daniel Nikpayuk
**
** This file is part of translate_table.
**
** translate_table is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
** as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
**
** translate_table is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
** of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License along with translate_table. If not, see
** <http://www.gnu.org/licenses/>.
**
*************************************************************************************************************************/

#ifndef TRANSLATE_TABLE_H
#define TRANSLATE_TABLE_H

#include<list>
#include<fstream>

#include"../nik/nik_encoding.h"
#include"../nik/nik_policy.h"
#include"../nik/nik_algorithm.h"
#include"../nik/nik_plot.h"

class translate_table
{
	public:
		typedef typename nik::utf8::int_type int_type;
		typedef nik::sub_vector<int_type> vector;
		typedef nik::plot<nik::vector, vector> plot;
		typedef nik::plot<nik::vector, plot> entry;
		typedef nik::plot<nik::vector, entry> word_table;

		typedef word_table::sub_type word_entry;
		typedef entry::sub_type word_plot;
		typedef plot::sub_type word_vector;

		typedef word_table::const_iterator table_iterator;
		typedef entry::const_iterator entry_iterator;
		typedef plot::const_iterator plot_iterator;
		typedef plot::sub_const_iterator vector_iterator;

		typedef std::string::const_iterator str_iterator;
	private:
		std::fstream file;

		word_plot headers;
		word_plot defaults;

		word_table table;
	private:
		word_vector to_word(const char c_str[])
		{
			word_vector word;
			std::string str(c_str);
			nik::utf8::map(str.begin(), str.end(), word);
			return word;
		}
		std::string to_string(const word_vector & word)
		{
			std::string str;
			for (vector_iterator k=word.begin(); k != word.end(); ++k) str+=nik::utf8::from_int(*k);
			return str;
		}
	private:
		void get_field(word_vector & vec, str_iterator & first, str_iterator last)
		{
			std::string field;
			while (first != last)
			{
				if (*first == ',') { ++first; break; }
				else if (*first != ' ' && *first != '\t') field+=*first;
				++first;
			}
			nik::utf8::map(field.begin(), field.end(), vec);
		}
		void parse_default()
		{
			std::string line;
			while (getline(file, line) && !line.empty())
			{
				str_iterator k=line.begin();

				word_vector h;
				get_field(h, k, line.end());
				int offset=nik::abstract::find<nik::sort_policy::lexicographic_ascending,
					nik::filter_policy::dereference>(headers.begin(), headers.end(), h)-headers.begin();
				headers.insert(std::next(headers.begin(), offset), h);

				word_vector d;
				get_field(d, k, line.end());
				defaults.insert(std::next(defaults.begin(), offset), d);
			}
		}
		void read_default(const char filename[])
		{
			file.open(filename, std::fstream::in);
			if (file.is_open())
			{
				parse_default();
				file.close();
			}
		}
	private:
		void push_line(word_plot & pl, const std::string & line)
		{
			str_iterator k=line.begin();
			while (k != line.end())
			{
				pl.push_back(word_vector());
				get_field(pl.back(), k, line.end());
			}
		}
		#define HEADER_OFFSET 3
		void get_head(word_plot & head)
		{
			std::string line;
			while (getline(file, line) && line.empty()) ;// do nothing
			push_line(head, line);
			while (head.size() > HEADER_OFFSET) head.pop_back();
		}
		void get_names(word_plot & names)
		{
			std::string line;
			getline(file, line);
			push_line(names, line);
		}
		void get_lines(word_entry & entry)
		{
			std::string line;
			while (getline(file, line) && !line.empty())
			{
				entry.push_back(word_plot());
				push_line(entry.back(), line);
			}
		}
		void get_entry(word_plot & head, word_plot & names, word_entry & entry)
		{
			get_head(head);
			get_names(names);
			get_lines(entry);
		}
		void make_entry(word_plot & head, const word_plot & names, const word_entry & entry)
		{
			for (plot_iterator k=defaults.begin(); k != defaults.end(); ++k) head.push_back(*k);

			word_entry table_entry;
			std::vector<plot_iterator> comb;
			for (entry_iterator k=entry.begin(); k != entry.end(); ++k)
			{
				table_entry.push_back(head);
				comb.push_back((*k).begin());
			}

			for (plot_iterator k=names.begin(); k != names.end(); ++k)
			{
				int offset=HEADER_OFFSET+(nik::abstract::find<nik::sort_policy::lexicographic_ascending,
					nik::filter_policy::dereference>(headers.begin(), headers.end(), *k)-headers.begin());
				std::vector<plot_iterator>::iterator it=comb.begin();
				for (entry::iterator j=table_entry.begin(); j != table_entry.end(); ++j, ++it)
					*std::next((*j).begin(), offset)=*((*it)++);
			}

			table.push_back(table_entry);
		}
		#undef HEADER_OFFSET
		void parse_entries()
		{
			while (!file.eof())
			{
				word_plot head;
				word_plot names;
				word_entry entry;
				get_entry(head, names, entry);
				make_entry(head, names, entry);
			}
		}
		void read(const char filename[])
		{
			file.open(filename, std::fstream::in);
			if (file.is_open())
			{
				parse_entries();
				file.close();
			}
		}
	private:
		void write(const std::string & filename)
		{
			file.open(filename, std::fstream::out);
			if (file.is_open())
			{
				file << "Number, Nation, Auditor, ";
				for (plot_iterator k=headers.begin(); k != headers.end(); ++k)
				{
					file << to_string(*k);
					if (std::next(k) != headers.end()) file << ", ";
				}
				file << std::endl;
				for (table_iterator k=table.begin(); k != table.end(); ++k)
					for (entry_iterator j=(*k).begin(); j != (*k).end(); ++j)
					{
						for (plot_iterator i=(*j).begin(); i != (*j).end(); ++i)
						{
							file << to_string(*i);
							if (std::next(i) != (*j).end()) file << ", ";
						}
						file << std::endl;
					}
				file.close();
			}
		}
	public:
		translate_table(const char infile[], const char outfile[], const char defaultfile[])
		{
			read_default(defaultfile);
			read(infile);
			write(outfile);
		}
};

#endif
