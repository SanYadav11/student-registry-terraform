package com.example.student.repo;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.student.model.Student;




public interface StudentRepository extends JpaRepository<Student, Integer> {
	
	Optional<Student> findById(int id);
	
	Optional<Student> findByName(String name);
	
	List<Student> findAllByName(String name);
	
}
