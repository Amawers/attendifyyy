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