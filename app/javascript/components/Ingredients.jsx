import { Table, message, Popconfirm } from "antd";
import React from "react";
import AddIngredientModal from "./AddIngredientModal";

class Ingredients extends React.Component {
	columns = [
		{
			title: "Title",
			dataIndex: "title",
			key: "title",
		},
		{
			title: "Description",
			dataIndex: "description",
			key: "description",
		},
		{
			title: "",
			key: "action",
			render: (_text, record) => (
				<Popconfirm
					title="Are you sure delete this ingredient?"
					onConfirm={() => this.deleteIngredient(record.id)}
					okText="Yes"
					cancelText="No"
				>
					<a href="#" type="danger">
						Delete{" "}
					</a>
				</Popconfirm>
			),
		},
	];

	state = {
		ingredients: [],
	};

	componentDidMount() {
		this.loadIngredients();
	}

	loadIngredients = () => {
		const url = "ingredients/index";
		fetch(url)
			.then((data) => {
				if (data.ok) {
					return data.json();
				}
				throw new Error("Network error.");
			})
			.then((data) => {
				data.forEach((ingredient) => {
					const newEl = {
						key: ingredient.id,
						id: ingredient.id,
						title: ingredient.title,
						description: ingredient.description,
					};

					this.setState((prevState) => ({
						ingredients: [...prevState.ingredients, newEl],
					}));
				});
			})
			.catch((err) => message.error("Error: " + err));
	};

	reloadIngredients = () => {
		this.setState({ ingredients: [] });
		this.loadIngredients();
	};

	render() {
		return (
			<>
				<Table
					className="table-striped-rows"
					dataSource={this.state.ingredients}
					columns={this.columns}
					pagination={{ pageSize: 5 }}
				/>
			</>
		);
	}
}

export default Ingredients;
