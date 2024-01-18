// create table
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255),
    phone_number VARCHAR(20),
    department VARCHAR(255)
);

CREATE TABLE sections (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    semester VARCHAR(255),
    section_name VARCHAR(255)
);

CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(255),
    subject_code VARCHAR(255)
);

CREATE TABLE subject_teachers (
    subject_teachers_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT,
    teacher_id INT,
    section_id INT,
    constraint subject_teachers_section_id_fkey foreign key (section_id) references sections (section_id),
    constraint subject_teachers_subject_id_fkey foreign key (subject_id) references subjects (subject_id),
    constraint subject_teachers_teacher_id_fkey foreign key (teacher_id) references teachers (teacher_id)
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    email VARCHAR(255),
    grade_level VARCHAR(255),
    last_name VARCHAR(255),
    reference_number VARCHAR(255),
    middle_initial VARCHAR(255),
    course VARCHAR(255)
);

CREATE TABLE student_subjects (
    student_subjects_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    section_id INT NOT NULL,
    constraint student_subjects_section_id_fkey foreign key (section_id) references sections (section_id),
    constraint student_subjects_student_id_fkey foreign key (student_id) references students (student_id),
    constraint student_subjects_subject_id_fkey foreign key (subject_id) references subjects (subject_id)
);

CREATE TABLE class_schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT NOT NULL,
    subject_id INT NOT NULL,
    section_id INT NOT NULL,
    start_time TIME,
    end_time TIME,
    day_of_week TEXT,
    CONSTRAINT class_schedules_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES subjects (subject_id),
    CONSTRAINT class_schedules_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id),
    CONSTRAINT class_schedules_section_id_fkey FOREIGN KEY (section_id) REFERENCES sections (section_id)
);

CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    schedule_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    attendance_time time NOT null,
    attendance_status text NOT null,
    constraint attendance_schedule_id_fkey foreign key (schedule_id) references class_schedules (schedule_id)
);
