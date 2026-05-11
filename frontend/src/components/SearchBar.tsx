type Props = {
  value: string;
  onChange: (value: string) => void;
  loading: boolean;
};

const SearchBar = ({ value, onChange, loading }: Props) => {
  return (
    <div className="search-wrapper">
      <input
        type="text"
        className="search-input"
        placeholder="Search by drink name…"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        autoFocus
      />
      {loading && <span className="search-spinner" />}
    </div>
  );
};
export default SearchBar;
